# http://samsaffron.com/archive/2013/11/22/demystifying-the-ruby-gc
# https://tunemygc.com/
# http://stackoverflow.com/questions/21367038/why-does-iterating-over-data-result-in-massive-memory-usage
# 
# h3d@web2:/var/www/h3d_forum/current$ ruby --version
# ruby 2.1.0p0 (2013-12-25 revision 44422) [x86_64-linux]
#

require 'htmlentities'

t0 = Time.now

roots = H3d::Forum.roots.order("title")
admin = H3d::User.where(login: 'admin').first
position = 0

deleted_user = User.where(username: "user_deleted", email: "user@deleted").first_or_create

RateLimiter.disable

# clear out posts from topics that weren't fully processed so that they can be processed again
puts "Clearing out any posts from failed imports.."
=begin
topics = H3d::Topic.where("discourse_topic_id is not null").select("id, discourse_topic_id").to_a
cnt = topics.count
i = 0
topics = topics.find_all{ |h3d_t| 
  i += 1
  if i % 100 == 0
    puts "part 1: #{(i.to_f / cnt.to_f * 100.0).to_i}%"
  end
  h3d_t.posts.count != h3d_t.discourse_topic.posts.count
}
=end

# quicker implementation
h3d_topics = H3d::Topic.where("discourse_topic_id is not null")
h3d_topic_cnts = h3d_topics.joins(:posts).group(:topic_id).count
discourse_topic_cnts = Topic.joins(:posts).group(:topic_id).count

h3d_topics_to_delete_ids = []
cnt = h3d_topics.count
h3d_topics.select('id, discourse_topic_id').each_with_index do |h3d_t, i|
  if i % 1000 == 0
    puts "part 1: #{(i.to_f / cnt.to_f * 100.0).to_i}%"
  end
  if h3d_topic_cnts[h3d_t.id] != discourse_topic_cnts[h3d_t.discourse_topic_id]
    h3d_topics_to_delete_ids << h3d_t.id
  end
end

h3d_topics_to_delete = H3d::Topic.find(h3d_topics_to_delete_ids)
cnt = h3d_topics_to_delete.count
puts "#{cnt} h3d topics to delete all discourse posts for, and reimport"
h3d_topics_to_delete.each_with_index do |h3d_t, i|
  if i % 10 == 0
    puts "part 2: #{(i.to_f / cnt.to_f * 100.0).to_i}%"
  end
  h3d_t.discourse_topic.posts.collect(&:destroy) if h3d_t.discourse_topic
  h3d_t.posts.update_all(discourse_post_id: nil)
end

# try setting things nil to let GC get it
h3d_topics = h3d_topics_cnts = discourse_topic_cnts = h3d_topics_to_delete_ids = nil

# delete orphan topics
puts "Deleting orphan topics"
h3d_topic_discourse_topic_ids = H3d::Topic.pluck(:discourse_topic_id);
topic_ids = Topic.pluck(:id)
orphan_topics = Topic.where(id: (topic_ids - h3d_topic_discourse_topic_ids))
orphan_topics.collect{ |t| t.posts.update_all(deleted_at: Time.now) }
orphan_topics.update_all(deleted_at: Time.now)

puts "Deleting orphan posts"
h3d_post_discourse_post_ids = H3d::Post.where(is_spam: [nil, false]).pluck(:discourse_post_id);
post_ids = Post.pluck(:id)
orphan_posts = Post.where(id: (post_ids - h3d_post_discourse_post_ids))
orphan_posts.update_all(deleted_at: Time.now)

puts "Done"

h3d_topic_discourse_topic_ids = topic_ids = orphan_topics = nil # tell GC that it can reclaim topics
h3d_post_discourse_post_ids = post_ids = orphan_posts = nil # tell GC that it can reclaim posts

GC.start

# get a total count
forum_ids = []
roots.each do |r_|
  r = r_.clone
  forum_ids << r.id
  (r.children + r.children.collect(&:children)).flatten.each do |f_|
    forum_ids << f_.id
  end
end
total = H3d::Topic.where(forum_id: forum_ids).count.to_f

# go

roots.each do |r_|
  r = r_.clone

  puts "=== ROOT #{r.title} ==="

  (r.children + r.children.collect(&:children)).flatten.each do |f_|
    f = f_.clone

    puts "=== #{f.title} ==="
    puts "=== Forum data: #{f.inspect}"

    c = f.discourse_category

    f.topics.find_each do |h3d_t_|
      h3d_t = h3d_t_.clone

      cnt += 1
      puts "=== #{f.title} (#{(cnt / total * 100).round(1)}%) === Topic: #{h3d_t.title}"
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
        t.bumped_at = h3d_t.created_at
        update_post_stats = true

        # find a unique title name
        i = 1
        while Topic.where("LOWER(title) = LOWER(?)", t.title).present?
          i += 1
          t.title = HTMLEntities.new.decode(h3d_t.title) + " (#{i})"
        end

        puts "=== Creating topic: #{t.inspect}"
        puts "     -> h3d #{h3d_t.user.inspect}"

        t.save!

        h3d_t.discourse_topic_id = t.id
        h3d_t.save!
      else
        t = h3d_t.discourse_topic
      end

      # posts
      h3d_t.posts.each do |h3d_p_|
        h3d_p = h3d_p_.clone

        unless h3d_p.discourse_post_id || h3d_p.body.blank?
          puts "=== Post h3d id #{h3d_p.id}"
          p = Post.new
          p.user = h3d_p.user.try(:discourse_user) || deleted_user 
          p.topic_id = t.id
          p.raw = h3d_p.body
          p.created_at = h3d_p.created_at
          p.updated_at = h3d_p.updated_at
          p.reply_to_post_number = h3d_p.parent.try(:discourse_post).try(:post_number)
          p.save!

          # store ref in h3d_p
          h3d_p.discourse_post_id = p.id
          h3d_p.save!

          update_post_stats = true
        end
        h3d_p = nil
      end

      t.reload if t
      if h3d_t.posts.empty? || (t && t.posts.empty?)
        puts "NO POSTS ON h3d TOPIC #{h3d_t.id}, DESTROYING"
        h3d_t.discourse_topic_id = nil
        h3d_t.save!
        t.destroy if t
      elsif update_post_stats || true
        # Update attributes on the topic - featured users and last posted.
        @post = t.posts.last
        attrs = {last_posted_at: @post.created_at, last_post_user_id: @post.user_id}
        attrs[:bumped_at] = @post.created_at unless @post.no_bump
        attrs[:word_count] = t.posts.inject(0) { |cnt,p| cnt + p.word_count }
        attrs[:excerpt] = t.posts.first.excerpt(220, strip_links: true) unless t.excerpt.present?
        t.update_attributes(attrs)
        Topic.reset_highest(t.id)
      end

      h3d_t = nil

      #puts "Press Enter to continue"
      #STDIN.gets
    end

    f = nil
    GC.start

    #puts "Press Enter to continue"
    #STDIN.gets
  end

  r = nil
  GC.start
end

RateLimiter.enable

puts "Took #{Time.now - t0} seconds to run"

Category.all.collect(&:update_latest)

Topic.where("bumped_at > ?", Time.now).update_all(pinned_at: Time.now)
