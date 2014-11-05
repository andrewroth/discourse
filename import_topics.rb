require 'htmlentities'

t0 = Time.now

roots = H3d::Forum.roots.order("title")
admin = H3d::User.where(login: 'admin').first
position = 0

deleted_user = User.where(username: "user_delete", email: "user@deleted").first_or_create

RateLimiter.disable

roots.each do |r|
  puts "=== ROOT #{r.title} ==="

  r.children.each do |f|

    puts "=== #{f.title} ==="
    puts "=== Forum data: #{f.inspect}"

    c = f.discourse_category

    f.topics.each do |h3d_t|
      puts "=== Topic: #{h3d_t.title}"
      next unless h3d_t.title.present?

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
          p.reply_to_post_number = h3d_p.parent.try(:discourse_post_id)
          p.save!

          # store ref in h3d_p
          h3d_p.discourse_post_id = p.id
          h3d_p.save!
        end
      end
    end
  end
end

RateLimiter.enable

puts "Took #{Time.now - t0} seconds to run"
