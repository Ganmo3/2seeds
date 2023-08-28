class Public::PostFavoritesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
 
    if current_user.guest_user?
      flash[:alert] = "ゲストユーザーはいいねできません。"
    else
      @post_favorite = current_user.post_favorites.new(post_id: @post.id)
      @post_favorite.save
    # redirect_to request.referer
    
    # いいね通知を作成
    #post = Post.find(params[:post_id])
    #@post.create_notification_favorite_post!(current_user, @post_favorite.user_id, @post_favorite.post_id)
    end
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    @post_favorite = current_user.post_favorites.find_by(post_id: @post.id)
    @post_favorite.destroy
    # redirect_to request.referer
  end
end
