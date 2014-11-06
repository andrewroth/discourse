require 'htmlentities'

t0 = Time.now

roots = H3d::Forum.roots.order("title")
admin = H3d::User.where(login: 'admin').first
position = 0

deleted_user = User.where(username: "user_deleted", email: "user@deleted").first_or_create

RateLimiter.disable

# clear out posts from topics that weren't fully processed so that they can be processed again
puts "Clearing out any posts from failed imports.."
topics = H3d::Topic.where("discourse_topic_id is not null").select("id, discourse_topic_id").to_a.find_all{ |h3d_t| h3d_t.posts.count != h3d_t.discourse_topic.posts.count }
topics.each do |h3d_t| h3d_t.discourse_topic.posts.collect(&:destroy); h3d_t.posts.update_all(discourse_post_id: nil); end
puts "Done"

# go

roots.each do |r|
  puts "=== ROOT #{r.title} ==="

  r.children.each do |f|

    puts "=== #{f.title} ==="
    puts "=== Forum data: #{f.inspect}"

    c = f.discourse_category

    f.topics.each do |h3d_t|
      puts "=== #{f.title} === Topic: #{h3d_t.title}"
      next unless h3d_t.title.present?

      update_post_stats = false

      unless h3d_t.discourse_topic_id
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

        t.save!

        h3d_t.discourse_topic_id = t.id
        h3d_t.save!
      else
        t = h3d_t.discourse_topic
      end

      # posts
      h3d_t.posts.each do |h3d_p|
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

      #puts "Press Enter to continue"
      #STDIN.gets
    end
    #puts "Press Enter to continue"
    #STDIN.gets
  end
end

RateLimiter.enable

puts "Took #{Time.now - t0} seconds to run"

Category.all.collect(&:update_latest)
