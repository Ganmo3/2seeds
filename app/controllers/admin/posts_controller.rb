class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  
  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      flash[:success] = '投稿を削除しました。'
    else
      flash[:alert] = '投稿の削除に失敗しました。'
    end
    redirect_to admin_toot_path
  end
end
