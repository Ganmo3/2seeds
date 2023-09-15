class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!
  def destroy
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    @comments = Comment.where(post_id: params[:post_id]).order(created_at: :desc)
    redirect_to request.referer, notice: "コメントを削除しました。"
  end
end