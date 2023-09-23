class CommentFavorite < ApplicationRecord
  belongs_to :user
  belongs_to :comment
  has_many   :notifications, dependent: :destroy
  
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
  
end