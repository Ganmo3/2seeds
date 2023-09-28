class CommentFavorite < ApplicationRecord
  belongs_to :user
  belongs_to :comment
  has_many   :notifications, dependent: :destroy
end