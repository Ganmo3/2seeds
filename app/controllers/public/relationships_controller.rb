class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @user = User.find_by(account: params[:account])
    current_user.follow(@user)
    
    # フォロー通知を作成・保存
    @user.create_notification_follow!(current_user)
    
    #redirect_to request.referer, notice: "フォローしました"
  end
  
  def destroy
    @user = User.find_by(account: params[:account])
    current_user.unfollow(@user)
    #redirect_to  request.referer, notice: "フォローを解除しました"
  end
end
