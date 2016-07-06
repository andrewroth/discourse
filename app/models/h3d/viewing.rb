module H3d
  class Viewing < ActiveRecord::Base
    self.table_name = 'discussion_viewings'
    belongs_to :topic, :counter_cache => :view_count
    belongs_to :user
    belongs_to :last_post, :class_name => "H3d::Post"
    belongs_to :forum
  end
end
