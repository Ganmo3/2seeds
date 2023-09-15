class Public::UsersController < ApplicationController
  #before_action :sign_out_user, only: :show
  before_action :set_user, except: [:edit, :update, :withdraw_input, :withdraw_process]
  before_action :authenticate_user!, except: [:show]

  def show
    @latest_post = @user.posts.published.order(created_at: :desc).first
    @posts = @user.posts.published.where.not(id: @latest_post&.id).order(created_at: :desc).page(params[:page]).per(10)
    @total_views = @user.posts.published.sum(&:impressions_count)
    @post_ranking = @user.posts.published.order(impressions_count: :desc).limit(5)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if current_user.guest_user?
      flash[:error] = "ゲストユーザーは更新できません。"
      redirect_to request.referer
    else
      if @user.update(user_params)
        flash[:success] = "ユーザー情報を更新しました。"
        redirect_to user_path(@user)
      else
        render :edit
      end
    end
  end

  def withdraw_input
    @user = current_user
  end

  def withdraw_process
    user = current_user
  
    if user.guest_user?
      flash[:error] = "ゲストユーザーは退会できません。"
      redirect_to request.referer
    else
      user.update(status: :inactive)
      reset_session
      redirect_to root_path, notice: "退会しました。"
    end
  end

  def follower_list
    @followers = @user.followers
    render partial: "follower_list"
  end

  def following_list
    @followings = @user.followings
    render partial: "following_list"
  end

  def liked_posts
    @liked_posts = current_user.post_favorites.includes(:post).order(created_at: :desc).map(&:post)
  end

  private

  def set_user
    account_str = params[:account]
    sanitized_account_str = account_str.gsub(/[^a-zA-Z0-9_-]/, '')
    account_sym = sanitized_account_str.to_sym
    @user = User.find_by(account: account_sym)
  end

  def user_params
    params.require(:user).permit(:nickname, :account, :email, :introduction, :icon, :channel)
  end
end