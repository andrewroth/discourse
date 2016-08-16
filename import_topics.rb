# http://samsaffron.com/archive/2013/11/22/demystifying-the-ruby-gc
# https://tunemygc.com/
# http://stackoverflow.com/questions/21367038/why-does-iterating-over-data-result-in-massive-memory-usage
# 
# h3d@web2:/var/www/h3d_forum/current$ ruby --version
# ruby 2.1.0p0 (2013-12-25 revision 44422) [x86_64-linux]
#

#H3d::Topic.update_all(discourse_topic_id: nil)
#H3d::Post.update_all(discourse_post_id: nil)
#Post.delete_all
#Topic.delete_all
#User.where("id >= 5").delete_all
#TopicTag.delete_all
#Tag.delete_all

require 'htmlentities'

t0 = Time.now

roots = H3d::Forum.roots.order("title")
admin = H3d::User.where(login: 'admin').first
discourse_admin = User.where(name: "system").first
discourse_admin.update(staged: true)

position = 0

deleted_user = User.where(username: "user_deleted", email: "user@deleted").first_or_create

RateLimiter.disable

keep_topics = []

# quicker implementation
h3d_topics = H3d::Topic.where("discourse_topic_id is not null")
h3d_topic_cnts = h3d_topics.joins(:posts).group(:topic_id).count
discourse_topic_cnts = Topic.joins(:posts).group(:topic_id).count

h3d_topics_to_delete_ids = []
cnt = h3d_topics.count
h3d_topics.select('id, discourse_topic_id, title').each_with_index do |h3d_t, i|
  if i % 1000 == 0
    Rails.logger.info "part 1: #{(i.to_f / cnt.to_f * 100.0).to_i}%"
  end
  if h3d_topic_cnts[h3d_t.id] != discourse_topic_cnts[h3d_t.discourse_topic_id]
    puts "h3d_topic #{h3d_t.id} posts count #{h3d_topic_cnts[h3d_t.id]} discourse topic id #{h3d_t.discourse_topic_id} posts count #{discourse_topic_cnts[h3d_t.discourse_topic_id]}"
    puts "  -> h3d #{h3d_t.title}"
    puts "  -> discourse #{Topic.where(id: h3d_t.discourse_topic_id).pluck(:title)}"
    h3d_topics_to_delete_ids << h3d_t.id
  end
end

#throw h3d_topics_to_delete_ids.length

h3d_topics_to_delete = H3d::Topic.find(h3d_topics_to_delete_ids)
cnt = h3d_topics_to_delete.count
Rails.logger.info "#{cnt} h3d topics to delete all discourse posts for, and reimport"
h3d_topics_to_delete.each_with_index do |h3d_t, i|
  if i % 10 == 0
    Rails.logger.info "part 2: #{(i.to_f / cnt.to_f * 100.0).to_i}%"
  end
  h3d_t.discourse_topic.posts.collect(&:destroy) if h3d_t.discourse_topic
  h3d_t.posts.update_all(discourse_post_id: nil)
end

# try setting things nil to let GC get it
h3d_topics = h3d_topics_cnts = discourse_topic_cnts = h3d_topics_to_delete_ids = nil

# delete orphan topics
Rails.logger.info "Deleting orphan topics"
#h3d_topic_discourse_topic_ids = H3d::Topic.pluck(:discourse_topic_id); # wtf pluck uses discourse db
h3d_topic_discourse_topic_ids = H3d::Topic.select(:discourse_topic_id).collect(&:discourse_topic_id)
topic_ids = Topic.pluck(:id)
orphan_topics = Topic.where(id: (topic_ids - h3d_topic_discourse_topic_ids))
orphan_topics.collect{ |t| t.posts.update_all(deleted_at: Time.now) }
orphan_topics.update_all(deleted_at: Time.now)

Rails.logger.info "Deleting orphan posts"
h3d_post_discourse_post_ids = H3d::Post.where(is_spam: [nil, false]).select(:discourse_post_id).collect(&:discourse_post_id);
post_ids = Post.pluck(:id)
orphan_posts = Post.where(id: (post_ids - h3d_post_discourse_post_ids))
orphan_posts.update_all(deleted_at: Time.now)

Rails.logger.info "Done"

h3d_topic_discourse_topic_ids = topic_ids = orphan_topics = nil # tell GC that it can reclaim topics
h3d_post_discourse_post_ids = post_ids = orphan_posts = nil # tell GC that it can reclaim posts

GC.start

# get a total count
forum_ids = []
roots.each do |r_|
  r = r_.clone
  forum_ids << r.id
  (r.children + r.children.collect(&:children)).flatten.each do |f_|
    next unless f_.discourse_keep
    forum_ids << f_.id
  end
end
total = H3d::Topic.where(forum_id: forum_ids).count.to_f

# go

k = 0

RateLimiter.disable
class Validators::PostValidator < ActiveModel::Validator
  def validate(record)
    Rails.logger.info "OUR VALIDATE HERE"
    presence(record)
  end
end

roots.each do |r_|
  r = r_.clone

  Rails.logger.info "=== ROOT #{r.title} ==="

  (r.children + r.children.collect(&:children)).flatten.each do |f_|
    f = f_.clone

    # TODO: Remove this later!!  We're just using MEL as a test
    #next unless f.title == "MEL"

    Rails.logger.info "=== #{f.title} ==="
    #Rails.logger.info "=== Forum data: #{f.inspect}"

    c = f.discourse_category
    if f.discourse_keep && c.nil?
      raise("Need to create discourse category #{f.discourse_category_name}")
    elsif !f.discourse_keep
      Rails.logger.info "=== SKIP DISCOURSE IMPORT ==="
      next
    end

    if f.discourse_tag.present?
      discourse_tag = Tag.where(name: f.discourse_tag).first_or_create
    else
      discourse_tag = nil
    end

    f.topics.order(updated_at: :desc).each do |h3d_t_|
      h3d_t = h3d_t_.clone
      keep_topics << h3d_t.id

      # TODO remove this before doing the real import -- just want to test first 10
      #k += 1
      #exit(0) if k > 50 

      cnt += 1
      Rails.logger.info "=== [ABORT INDEX #{k}/10] #{f.title} (#{(cnt / total * 100).round(1)}%) === Topic: #{h3d_t.title}"
      next unless h3d_t.title.present?

      update_post_stats = false

      unless h3d_t.discourse_topic
        t = Topic.new
        t.category = c
        t.user = h3d_t.user.try(:discourse_user) || deleted_user
        t.views = h3d_t.view_count
        t.closed = h3d_t.locked
        t.created_at = h3d_t.created_at
        t.updated_at = h3d_t.updated_at
        t.title = HTMLEntities.new.decode(h3d_t.title)
        t.bumped_at = h3d_t.updated_at
        t.pinned_at = h3d_t.updated_at if h3d_t.created_at > Time.now
        t.acting_user = discourse_admin
        update_post_stats = true

        # find a unique title name
        i = 1
        while Topic.where("LOWER(title) = LOWER(?)", t.title).present?
          i += 1
          t.title = HTMLEntities.new.decode(h3d_t.title) + " (#{i})"
        end

        Rails.logger.info "=== Creating topic: #{t.inspect}"
        Rails.logger.info "     -> h3d #{h3d_t.user.inspect}"

        t.save!(validate: false)

        h3d_t.discourse_topic_id = t.id
        h3d_t.save!

        # tags
        if discourse_tag.present?
          t.topic_tags.where(tag_id: discourse_tag.id).first_or_create
        end
      else
        t = h3d_t.discourse_topic
      end

      # no need to process posts if nothing's changed
      if h3d_t.children_updated_at.present? && 
        t.updated_at.present? && 
        h3d_t.children_updated_at == t.updated_at
        #puts "SKIPPING BECAUSE NOTHING HAS CHANGED (#{h3d_t.children_updated_at})"
        Rails.logger.info " === SKIPPING #{h3d_t.title} BECAUSE NOTHING HAS CHANGED (#{h3d_t.children_updated_at})"
        next
      end

      # posts
      h3d_t.posts.each do |h3d_p_|
        h3d_p = h3d_p_.clone

        unless h3d_p.discourse_post_id || h3d_p.body.blank?
          Rails.logger.info "=== Post h3d id #{h3d_p.id}"
          p = Post.new
          p.user = h3d_p.user.try(:discourse_user) || deleted_user 
          p.topic_id = t.id
          p.raw = h3d_p.body_to_bbcode
          p.created_at = h3d_p.created_at
          p.updated_at = h3d_p.updated_at
          p.reply_to_post_number = h3d_p.parent.try(:discourse_post).try(:post_number)
          p.acting_user = discourse_admin
          p.save!(validate: false)

          # store ref in h3d_p
          h3d_p.discourse_post_id = p.id
          h3d_p.save!

          update_post_stats = true
        end
        h3d_p = nil
      end

      t.reload if t
      if h3d_t.posts.empty? || (t && t.posts.empty?)
        Rails.logger.info "NO POSTS ON h3d TOPIC #{h3d_t.id}, DESTROYING"
        h3d_t.discourse_topic_id = nil
        h3d_t.save!
        t.destroy if t
      elsif update_post_stats || true
        # Update attributes on the topic - featured users and last posted.
        @post = t.posts.last
        attrs = {last_posted_at: @post.created_at, last_post_user_id: @post.user_id}

        u = h3d_t.try(:children_updated_at) # always trust children_updated_at
        if !u
          u = h3d_t.try(:updated_at)
        end
        if !u || u > 1.day.ago # don't trust updated_at new, could be from the h3d import
          u = h3d_t.posts.maximum(:created_at)
        end
        if !u || u > 1.day.ago
          u = h3d_t.created_at
        end
        attrs[:updated_at] = u
        attrs[:bumped_at] = u
=begin
  h3d_t = H3d::Topic.where(discourse_topic_id: t.id).last
  u = h3d_t.try(:children_updated_at)
  if !u || u > 1.day.ago
    u = h3d_t.posts.maximum(:created_at)
  end
  if !u || u > 1.day.ago
     u = h3d_t.created_at
  end
  t.update_column(:updated_at, u) if u
  t.update_column(:bumped_at, u) if u
=end
        attrs[:word_count] = t.posts.inject(0) { |cnt,p| cnt + p.word_count }
        attrs[:excerpt] = t.posts.first.excerpt(220, strip_links: true) unless t.excerpt.present?
        t.update_attributes(attrs)
        Topic.reset_highest(t.id)
      end

      h3d_t = nil

      #Rails.logger.info "Press Enter to continue"
      #STDIN.gets
    end

    f = nil
    GC.start

    #Rails.logger.info "Press Enter to continue"
    #STDIN.gets
  end

  r = nil
  GC.start
end

RateLimiter.enable

Rails.logger.info "Took #{Time.now - t0} seconds to run"

Category.all.collect(&:update_latest)

Post.where("created_at > ?", Time.now).each do |p|
  u = p.topic.posts.where("created_at < ?", Time.now).maximum(:created_at)
  if u.nil? || u > Time.now
    u = p.topic.posts.where("updated_at < ?", Time.now).maximum(:updated_at)
  end
  if u.nil? || u > Time.now
    u = p.topic.created_at
  end
  p.update_column(:created_at, u)
  p.update_column(:updated_at, u)
end

Topic.where("bumped_at > ?", Time.now).update_all(pinned_at: Time.now)

puts "Fixing bumped_at/updated_at:"
total = Topic.where("bumped_at > ? OR updated_at > ?", 1.month.ago, 1.month.ago).count
puts total
Rails.logger.info total

j = 0
Topic.where("bumped_at > ? OR updated_at > ?", 1.month.ago, 1.month.ago).find_each do |t|
  j += 1
  if j % 100 == 0
    s = "[#{j}/#{total} (#{(j / total.to_f * 100.0).round(1)}%)"
    puts s
    Rails.logger.info s
  end
  h3d_t = H3d::Topic.where(discourse_topic_id: t.id).last
  u = h3d_t.try(:children_updated_at)
  if !u || u > 1.day.ago
    u = h3d_t.posts.maximum(:created_at)
  end
  if !u || u > 1.day.ago
     u = h3d_t.created_at
  end
  t.update_column(:updated_at, u) if u
  t.update_column(:bumped_at, u) if u
end

# mark all topics in Archive category as archived
puts "Marking all archived posts as archived"
c = Category.find_by(name: 'Archived')
c.topics.update_all(archived: true)

puts "Go through post processing again to get the topic images"
j = 0
Topic.where("created_at > ?", 2.months.ago).where(image_url: nil).find_each do |t|
#Topic.where(image_url: nil).find_each do |t|
  j += 1
  #if j >= 10550
    Rails.logger.info("=== abc123 #{j} ===")
    p = t.posts.last
    if p
      begin
        Jobs::ProcessPost.new.execute(post_id: p.id)
      rescue Exception => e
        puts "ERROR ON Topic #{t.id}"
      end
    end
  #end
end

ids = H3d::Topic.where(forum_id: forum_ids).collect(&:id) - keep_topics
puts "DELETE #{ids.length}"
File.write("ids.rb", "@ids = #{ids.join(',')}")
puts "Done"
