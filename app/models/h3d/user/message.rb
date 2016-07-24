class H3d::User::Message < ActiveRecord::Base
  establish_connection :h3d

  belongs_to :discourse_topic, class_name: "::Topic"
  belongs_to :discourse_post, class_name: "::Post"
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"

  def create_discourse
    return unless subject.present? && subject.length >= 2

    unless discourse_topic
      self.discourse_topic = ::Topic.create! title: subject,
        last_posted_at: created_at,
        created_at: created_at,
        updated_at: updated_at,
        views: 1,
        user_id: sender.discourse_user.id,
        last_post_user_id: sender.discourse_user.id,
        reply_count: 0,
        highest_post_number: 1,
        bumped_at: created_at,
        archetype: "private_message"
      update_column :discourse_topic_id, discourse_topic.id
    end

    unless discourse_topic.posts.count > 0
      discourse_post = discourse_topic.posts.create! raw: body,
        user: sender.discourse_user,
        created_at: created_at,
        updated_at: updated_at
      update_column :discourse_post_id, discourse_post.id
    end

    if sender != nil
      discourse_topic.topic_users.where(user_id: sender.discourse_user.id, posted: true).first_or_create
      discourse_topic.topic_allowed_users.where(user_id: sender.discourse_user.id).first_or_create
    end
    if recipient != nil
      discourse_topic.topic_users.where(user_id: recipient.discourse_user.id).first_or_create
      discourse_topic.topic_allowed_users.where(user_id: recipient.discourse_user.id).first_or_create
    end
  end

  def self.create_discourse
    importing_before = ENV['importing']
    ENV['importing'] = 'true'
    total = H3d::User::Message.count
    i = H3d::User::Message.where("discourse_topic_id is not null AND discourse_post_id is not null").count
    base = H3d::User::Message.where("discourse_topic_id is null OR discourse_post_id is null")
    puts "[#{i}/#{total}]"
    base.find_each do |m|
      i += 1
      puts("#{name} IMPORT [#{i}/#{total}] #{(i.to_f / total.to_f * 100.0).round(1)}%") if i % 10 == 0
      m.create_discourse
    end
    ENV['importing'] = importing_before 
  end
end
