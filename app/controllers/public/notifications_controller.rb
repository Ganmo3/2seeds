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
  
  private
  
  def hide_header
    @show_header = false
  end
  
end
