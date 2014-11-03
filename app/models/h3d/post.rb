module H3d
  class Post < ActiveRecord::Base
    establish_connection :h3d
    self.table_name = "discussion_posts"

    scope :roots, -> { where("parent_id IS NULL or parent_id = 0 or parent_id = id") }
    scope :recent, ->(num) { order('created_at desc').limit(num || 5) }

    belongs_to :topic, :counter_cache => :children_count, :touch => true
    belongs_to :forum, :counter_cache => :posts_count
    belongs_to :user, :foreign_key => :created_by
    belongs_to :quote, :class_name => "H3d::Post", :foreign_key => "quote_id"
    belongs_to :parent, :class_name => "H3d::Post"
    belongs_to :discourse_post, class_name: "Post"

    has_many :children, foreign_key: "parent_id", class_name: "H3d::Post"
  end
end
