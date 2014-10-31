module H3d
  class TopicMentorship < ActiveRecord::Base
    self.table_name = 'discussion_topic_monitorship'
    belongs_to :topic
    belongs_to :user 
  end
end
