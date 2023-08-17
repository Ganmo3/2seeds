class Notification < ApplicationRecord
  
  default_scope -> { order(created_at: "DESC") }

  belongs_to :post, optional: true
  belongs_to :comment, optional: true
  belongs_to :post_favorite, optional: true
  belongs_to :comment_favorite, optional: true
  belongs_to :relationship, optional: true

  belongs_to :visitor, class_name: "User", foreign_key: "visitor_id", optional: true
  belongs_to :visited, class_name: "User", foreign_key: "visited_id", optional: true
end
