class Public::CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    
    if current_user.guest_user?
      flash[:alert] = "ゲストユーザーはコメントできません。"
    else
      @comment = current_user.comments.new(comment_params)
      @comment.post_id = params[:post_id]
      @comment.save
      
      # コメントの投稿に対する通知を作成・保存
      @post.create_notification_comment!(current_user, @comment.id)
      
      @comments = Comment.where(post_id: params[:post_id]).order(created_at: :desc)
      #redirect_to post_path(@post)
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    @comments = Comment.where(post_id: params[:post_id]).order(created_at: :desc)
    #redirect_back(fallback_location: root_path)
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
