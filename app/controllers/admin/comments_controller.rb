class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!
  
  def destroy
    @comment = Comment.find(params[:id])
    @post_id = @comment.post_id
    
    if @comment.destroy
      flash[:success] = "コメントを削除しました。"
    else
      flash[:error] = "コメントの削除に失敗しました。"
    end

    redirect_to request.referer
  end
end
