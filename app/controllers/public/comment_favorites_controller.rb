class Public::CommentFavoritesController < ApplicationController
  def create
    @comment = Comment.find(params[:comment_id])
    @comment_favorite = current_user.comment_favorites.new(comment_id: @comment.id)
    @comment_favorite.save
    # redirect_to request.referer
  end
  
  def destroy
    @comment = Comment.find(params[:comment_id])
    @comment_favorite = current_user.comment_favorites.find_by(comment_id: @comment.id)
    @comment_favorite.destroy
    # redirect_to request.referer
  end
end
