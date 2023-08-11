class Post < ApplicationRecord
  # gem:impressionableの使用
  is_impressionable

  belongs_to :user
  has_many :post_favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # hashtag機能
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  
  # 下書き機能
  attribute :is_draft, :boolean, default: false
  
  def save_draft
    self.is_draft = true
    save(validate: false)
  end
  
  # いいね機能
  def favorited_by?(user)
    user.present? && post_favorites.exists?(user_id: user.id)
  end
end
