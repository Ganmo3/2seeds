class Public::UsersController < ApplicationController
  before_action :set_user, except: [:edit, :update, :withdraw_input, :withdraw_process]
  before_action :hide_header, only: [:follower_list, :following_list]

  def show
    @posts = @user.posts
    @total_views = @user.posts.sum(&:impressionist_count)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def withdraw_input
    @user = current_user
  end

  def withdraw_process
    user = current_user
    user.update(status: :inactive)
    reset_session
    redirect_to root_path, notice: "退会しました"
  end

  def follower_list
    @followers = @user.followers
  end
  
  def following_list
    @followings = @user.followings
  end

  private
  
  def hide_header
    @show_header = false
  end

  def set_user
    account_str = params[:account] 
    sanitized_account_str = account_str.gsub(/[^a-zA-Z0-9_-]/, '') 
    account_sym = sanitized_account_str.to_sym 
    @user = User.find_by(account: account_sym) 
  end

  def user_params
    params.require(:user).permit(:nickname, :account, :email, :introduction, :icon, :anniversary, :channel)
  end
end
