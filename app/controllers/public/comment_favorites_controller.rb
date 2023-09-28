class Public::CommentFavoritesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @comment = Comment.find(params[:comment_id])
    @comment_favorite = current_user.comment_favorites.new(comment_id: @comment.id)
    @comment_favorite.save
    #redirect_to request.referer
    
    # いいね通知を作成
    post = Comment.find(params[:comment_id]).post  # コメントから関連する投稿を取得
    comment = Comment.find(params[:comment_id])     # コメントを取得
    if current_user != comment.user
      post.create_notification_favorite_comment!(current_user, comment, comment.id)
    end

  end
  
  def destroy
    @comment = Comment.find(params[:comment_id])
    @comment_favorite = current_user.comment_favorites.find_by(comment_id: @comment.id)
    @comment_favorite.destroy
    #redirect_to request.referer
  end
end
