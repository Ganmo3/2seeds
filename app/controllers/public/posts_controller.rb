class Public::PostsController < ApplicationController
  def index
    @posts = Post.all
  end
  
  def new
    @post = Post.new
  end
  
  def create
   @post = Post.new(post_params.merge(user_id: current_user.id))

    if params[:commit] == "下書き保存"
      @post.is_draft = true
    end
  
    if @post.save
      save_tags
      if @post.is_draft
        redirect_to drafts_posts_path, notice: '下書きが保存されました。'
      else
        redirect_to post_path(@post), notice: '投稿が公開されました。'
      end
    else
      render :new
    end
  end
  
  def drafts
    @published_posts = Post.where(user_id: current_user.id, is_draft: false).order(created_at: :desc)
    @draft_posts = Post.where(user_id: current_user.id, is_draft: true).order(created_at: :desc).page(params[:page]).per(8)
  end

  def show
    @post = Post.find(params[:id])
    impressionist(@post, nil, unique: [:session_hash]) # 同セッションでの重複閲覧をカウントしない
    @comment = Comment.new

    @comments = Comment.where(post_id: params[:id]).order(created_at: :desc)
    @post_tags = @post.tags
  end

  def edit
    @post = Post.find(params[:id])
    # @isdraft = is_draft?
  end
  
  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
     # tag_list = params[:post][:tag_name].split(nil)
      if params[:commit] == "下書き保存"
        @post.update(is_draft: true)
        #update_tags
        redirect_to posts_path, notice: "下書きを保存しました。"
      else
        @post.update(is_draft: false)
        #update_tags
        redirect_to @post, notice: "投稿を更新しました。"
      end
    else
      render :edit
    end
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end


  def share_on_twitter
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['YOUR_CONSUMER_KEY']
      config.consumer_secret = ENV['YOUR_CONSUMER_SECRET']
      config.access_token = ENV['USER_ACCESS_TOKEN']
      config.access_token_secret = ENV['USER_ACCESS_TOKEN_SECRET']
    end
    
    post = Post.find(params[:id])
    tweet_text = "Check out this post: #{post.title} - #{post.link}"
    
    client.update(tweet_text)
    
    redirect_to post_path(post), notice: 'Post successfully shared on Twitter!'
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :link)
  end
  
  def save_tags
  end
    
end
