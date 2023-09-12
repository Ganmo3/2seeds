class Public::NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notices = current_user.passive_notifications.order(created_at: :desc)
    @unchecked_notifications = @notices.where(is_checked: false)

    # 確認済みの通知を取得
    @checked_notifications = @notices.where(is_checked: true).page(params[:page]).without_count.per(2)
    @user = current_user

    #@notifications = @unchecked_notifications.or(@checked_notifications).order(created_at: :desc)


    # 通知を確認済みに更新
    current_user.passive_notifications.update_all(is_checked: true)
    render partial: "index"
  end

  def update_checked
    current_user.passive_notifications.update_all(is_checked: true)
    head :no_content
  end

end
