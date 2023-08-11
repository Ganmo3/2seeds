class Public::CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = params[:post_id]
    @comment.save
    @comments = Comment.where(post_id: params[:post_id]).order(created_at: :desc)
    #redirect_to post_path(@post)
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
