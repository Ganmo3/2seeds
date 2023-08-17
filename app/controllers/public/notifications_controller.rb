class Public::NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notices = current_user.passive_notifications.order(created_at: :desc)
    @unchecked_notifications = @notices.where(is_checked: false)

    # 確認済みの通知を取得
    @checked_notifications = @notices.where(is_checked: true)
    @user = current_user
  end
end
