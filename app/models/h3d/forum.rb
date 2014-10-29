module H3d
  class Forum < ActiveRecord::Base
    belongs_to :parent, :class_name => "H3d::Forum"

    establish_connection :h3d
    self.table_name = "discussion_forums"

    scope :global, -> { where("forum_of_id IS NULL") }
    scope :roots, -> { where("parent_id IS NULL") }
  end
end
