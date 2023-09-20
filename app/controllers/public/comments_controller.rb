class Public::CommentsController < ApplicationController
  before_action :set_comment, only: [:update, :destroy]
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    
    # if current_user.guest_user?
    #   flash[:alert] = "ゲストユーザーはコメントできません。"
    # else
      @comment = current_user.comments.new(comment_params)
      @comment.post_id = params[:post_id]
      @comment.save
      
      # コメントの投稿に対する通知を作成・保存
      @post.create_notification_comment!(current_user, @comment.id)
      
      @comments = Comment.where(post_id: params[:post_id]).order(created_at: :desc)
    # end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])

    if @comment.user == current_user
      @comment.destroy
      @comments = Comment.where(post_id: params[:post_id]).order(created_at: :desc)
    else
      redirect_to root_path, alert: 'コメントの削除権限がありません。'
    end
  end

  def update
    if @comment.update(comment_update_params)
    else
      @comment.reload
    end
  end
  
  private
  
  def set_comment
    @comment = current_user.comments.find(params[:id])
  end
  
  def comment_update_params
    params.require(:comment).permit(:comment)
  end

  def comment_params
    params.require(:comment).permit(:comment)
  end
end