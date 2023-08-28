class Public::NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :hide_header

  def index
    @notices = current_user.passive_notifications.order(created_at: :desc)
    @unchecked_notifications = @notices.where(is_checked: false)

    # 確認済みの通知を取得
    @checked_notifications = @notices.where(is_checked: true)
    @user = current_user
    
    # 通知を確認済みに更新
    current_user.passive_notifications.update_all(is_checked: true)
    
  end
  
  def update_checked
    current_user.passive_notifications.update_all(is_checked: true)
    head :no_content
  end
  
  def load_more_notifications
    offset = params[:offset].to_i
    limit = 5
    notices = current_user.passive_notifications.order(created_at: :desc)
    unchecked_notifications = notices.where(is_checked: false)
    notifications = unchecked_notifications.limit(limit).offset(offset)
    render partial: "notification", locals: { notifications: notifications }, layout: false
  end
  
  private
  
  def hide_header
    @show_header = false
  end
  
end
