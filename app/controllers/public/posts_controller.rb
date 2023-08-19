class Public::PostsController < ApplicationController
  before_action :hide_header, only: [:new, :edit]
  
  def index
    @posts = Post.all
    @user = current_user
    
    @posts.each do |post|
      impressionist(post, nil, unique: [:session_hash])
    end
  end

  def new
    @post = Post.new
    @user = current_user
  end

  def create
   @user = current_user
   @post = Post.new(post_params)
   # post = Post.new(post_params.merge(user_id: current_user.id))

    if params[:commit] == "下書き保存"
      @post.is_draft = true
    end

    if @post.save
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
    @user = current_user
  end

  def show
    @post = Post.find(params[:id])
    impressionist(@post, nil, unique: [:session_hash]) # 同セッションでの重複閲覧をカウントしない
    @comment = Comment.new
    @comments = Comment.where(post_id: params[:id]).order(created_at: :desc)
    
    @tags = @post.tag_counts_on(:tags) # 投稿に紐付くタグの表示

    @report = Report.new
    
    @user = current_user
  end

  def edit
    @post = Post.find(params[:id])
    # @isdraft = is_draft?
    @user = current_user
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      tag_list = params[:post][:tag_list].split(',').map(&:strip)
      @post.tag_list = tag_list
      
      if params[:commit] == "下書き保存"
        @post.update(is_draft: true)
        redirect_to posts_path, notice: "下書きを保存しました。"
      else
        @post.update(is_draft: false)
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
  
  def preview
    @preview_post = Post.new(post_params)
    @preview_tags = @preview_post.tag_list # Save tags temporarily
    @preview_post.tag_list = [] # Clear the tags
    render partial: 'preview', locals: { post: @preview_post, preview_tags: @preview_tags }
  end
  
  def autosave
    @post = Post.find(params[:id])
    if @post.update(autosave_params)
      render json: { success: true, message: '自動保存が完了しました。' }
    else
      render json: { success: false, errors: @post.errors.full_messages }
    end
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
  
  def hide_header
    @show_header = false
  end
  
  def autosave_params
    params.require(:post).permit(:title, :body, :link, :tag_list, :is_draft)
  end

  def post_params
    params.require(:post).permit(:title, :body, :link, :tag_list, :is_draft)
  end
end
