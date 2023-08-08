class Public::PostsController < ApplicationController
  def new
    @post = Post.new
  end
  
  def create

    # 下書き保存ボタンを押されたら
    if params[:commit] == "下書き保存"
      @post = Post.create(post_params.merge(user_id: current_user.id))
      if @post.save_draft
        save_hashtags
        redirect_to drafts_posts_path
      else
        render :new
      end
    else
      # 投稿ボタンが押されたら
      @post = Post.create(post_params.merge(user_id: current_user.id))
      if @post.save
        # save_tags
        redirect_to post_path(@post)
      else
        render :new
      end
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new

    @comments = Comment.where(post_id: params[:id]).order(created_at: :desc)
    @post_tags = @post.tags
  end


  private

  def post_params
    params.require(:post).permit(:title, :body, :link)
  end
    
end
