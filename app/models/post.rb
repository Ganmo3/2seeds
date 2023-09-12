class Post < ApplicationRecord
  # gem:impressionableの使用
  is_impressionable counter_cache: true, column_name: :impressions_count

  # gem:acts_as_taggableの使用
  acts_as_taggable_on :tags

  # action textの使用
  has_rich_text :body

  belongs_to :user
  has_many :post_favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # バリデーションの設定
  validates :title, presence: true
  validates :link, presence: true, format: { with: %r{\Ahttps?://(?:www\.)?youtube\.com/(?:watch\?v=|embed/|shorts/|v/)([\w-]{11})\z}i,
                                              message: "はYouTubeの正しい動画リンクである必要があります" }
  validates :body, presence: true, unless: -> { body.present? }


  enum status: { published: 0, draft: 1,  unpublished: 2 }


  # いいね機能
  def favorited_by?(user)
    user.present? && post_favorites.exists?(user_id: user.id)
  end

  # 3日間のいいね数のカウント
  def daily_likes_count(start_date, end_date)
    post_favorites.where("created_at >= ? AND created_at < ?", start_date.beginning_of_day, end_date.end_of_day).count
  end

  # デイリー視聴回数のカウント
  def daily_views_count(date)
    impressions.where("created_at >= ? AND created_at < ?", date.beginning_of_day, date.end_of_day).count
  end

  #　検索用
  def self.search_content(content, method)
    if method == "perfect"
      where(title: content)
    elsif method == "partial"
      where("title LIKE ?", "%#{content}%")
    else
      all
    end
  end

  # postへのいいね通知機能
def create_notification_favorite_post!(current_user, user_id, id)
  # すでに「いいね」されているかを検索
  existing_notification = Notification.find_by(visitor_id: current_user.id, visited_id: user_id, post_id: id, action: "favorite_post")

  # いいねされていない場合のみ、通知レコード作成
  if existing_notification.nil?
    notification = current_user.active_notifications.build(
      post_id: id,
      visited_id: user_id,
      action: "favorite_post"
    )

    # 自分の投稿に対するいいねの場合は、通知済みとする
    notification.is_checked = true if notification.visitor_id == notification.visited_id

    if notification.valid?
      notification.save
      # 通知の履歴を残すために通知を保存
      notification.reload
    end
  end
end


  # commentへのいいね通知機能
  def create_notification_favorite_comment!(current_user, comment_id)
    # すでに「いいね」されている検索
    existing_notification = Notification.find_by(visitor_id: current_user.id, visited_id: @comment.user_id, comment_id: comment_id, action: "favorite_comment")
    # いいねされていない場合のみ、通知レコード作成
    if existing_notification.blank?
      notification = current_user.active_notifications.new(
        comment_id: comment_id,
        visited_id: comment.user_id,
        action: "favorite_comment"
      )
      # 自分のコメントに対するいいねの場合は、通知済みとする
      notification.is_checked = true if notification.visitor_id == notification.visited_id

      if notification.valid?
        notification.save
        # 通知の履歴を残すために通知を保存
        notification.reload
      end
    end
  end


  # コメントが投稿された際に通知を作成するメソッド
  def create_notification_comment!(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    other_commenters_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct.pluck(:user_id)

    # 各コメントユーザーに対して通知を作成
    other_commenters_ids.each do |commenter_id|
      save_notification_comment!(current_user, comment_id, commenter_id)
    end

    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, comment_id, user_id) if other_commenters_ids.blank?
  end

  # 通知を保存するメソッド
  def save_notification_comment!(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.build(
      post_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )

    # 自分の投稿に対するコメントの場合は、通知済みとする
    notification.is_checked = true if notification.visitor_id == notification.visited_id

    # 通知を保存（バリデーションが成功する場合のみ）
    notification.save if notification.valid?
  end
end