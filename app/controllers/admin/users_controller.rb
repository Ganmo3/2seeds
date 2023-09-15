class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def update
     @user = User.find_by(account: params[:id])
    #byebug
    if @user.update(user_params)
      flash[:success] = "ステータスを更新しました。"
    else
      flash[:error] = "ステータスの更新に失敗しました。"
    end
    
    redirect_to request.referer
  end

  private

  def user_params
    params.require(:user).permit(:status)
  end
end
