class Public::UsersController < ApplicationController
  def show
    # ユーザーからの入力を取得
    account_str = params[:account]

    # 文字列から不要な文字（コロン以外の特殊文字など）を削除
    sanitized_account_str = account_str.gsub(/[^a-zA-Z0-9_]/, '')

    # 文字列をシンボルに変換
    account_sym = sanitized_account_str.to_sym

    # サニタイズされたシンボルを使用してクエリを実行
    @user = User.find_by(account: account_sym)
    # @user = User.find_by(account: params[:account])
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(user_params)
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

  private

  def user_params
    params.require(:user).permit(:nickname, :account, :email, :introduction, :icon)
  end
end
