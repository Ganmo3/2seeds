class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :comment_favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy
  
  validates :comment, presence: true
  
  # いいね機能
  def favorited_by?(user)
    user.present? && comment_favorites.exists?(user_id: user.id)
  end
end
