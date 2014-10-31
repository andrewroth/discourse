module H3d
  class Forum < ActiveRecord::Base
    establish_connection :h3d
    self.table_name = "discussion_forums"

    default_scope { global }

    scope :global, -> { where(forum_of_id: nil) }
    scope :roots, -> { where(parent_id: nil) }

    belongs_to :parent, :class_name => "H3d::Forum"
    belongs_to :discourse_category, class_name: "::Category"
    has_many :children, foreign_key: "parent_id", class_name: "H3d::Forum"
    has_many :topics, -> { order("created_at desc") }
  end
end
