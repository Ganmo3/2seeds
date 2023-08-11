class Public::PostFavoritesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @post_favorite = current_user.post_favorites.new(post_id: @post.id)
    @post_favorite.save
    # redirect_to request.referer
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    @post_favorite = current_user.post_favorites.find_by(post_id: @post.id)
    @post_favorite.destroy
    # redirect_to request.referer
  end
end
