class Public::PostFavoritesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @post = Post.find(params[:post_id])
 
    # if current_user.guest_user?
    #   flash[:alert] = "ゲストユーザーはいいねできません。"
    # else
      @post_favorite = current_user.post_favorites.new(post_id: @post.id)
      @post_favorite.save

      # 通知を作成（他のユーザーが自分の投稿にいいねした場合のみ）
      if current_user != @post.user
        @post.create_notification_favorite_post!(current_user)
      end
  # end
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    @post_favorite = current_user.post_favorites.find_by(post_id: @post.id)
    @post_favorite.destroy
  end
end
