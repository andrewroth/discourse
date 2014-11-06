module H3d
  class Topic < ActiveRecord::Base
    establish_connection :h3d
    self.table_name = "discussion_topics"

    has_many    :posts, :dependent => :destroy
    has_many    :monitorships, :class_name => 'H3d::TopicMonitorship', :foreign_key => :topic_id
    has_many    :viewings
    belongs_to  :forum, :counter_cache => :topics_count, :touch => true
    belongs_to  :last_post, :class_name => "H3d::Post"
    belongs_to  :user, :class_name => "H3d::User", :foreign_key => "created_by"
    belongs_to  :discourse_topic, :class_name => "::Topic"
  end
end
