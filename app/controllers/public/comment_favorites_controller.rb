class Public::CommentFavoritesController < ApplicationController
  def create
    @comment = Comment.find(params[:comment_id])
    @comment_favorite = current_user.comment_favorites.new(comment_id: @comment.id)
    @comment_favorite.save
     redirect_to request.referer
    
    # いいね通知を作成
    #post = Comment.find(params[:comment_id]).post  # コメントから関連する投稿を取得
    #post = @comment.post
   # post.create_notification_favorite_comment!(current_user, @comment.id)

  end
  
  def destroy
    @comment = Comment.find(params[:comment_id])
    @comment_favorite = current_user.comment_favorites.find_by(comment_id: @comment.id)
    @comment_favorite.destroy
     redirect_to request.referer
  end
end
