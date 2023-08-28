class Admin::UsersController < ApplicationController
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

def update
  @user = User.find_by(account: params[:id]) # accountに対応するカラム名を使ってユーザーを取得
  if @user.update(user_params)
    redirect_to request.referer, notice: "ステータスを更新しました。"
  else
    redirect_to request.referer, notice: "ステータスの更新に失敗しました。"
  end
end


  private

  def user_params
    params.require(:user).permit(:status)
  end
end
