class Public::PostsController < ApplicationController
  before_action :hide_header, only: [:new, :edit]

  def index
    @user = User.find_by(params[:account])
    
    if params[:sort] == 'favorites'
      @posts = Post.includes(:post_favorites).sort_by { |post| -post.post_favorites.count }
    else
      @posts = Post.all.order(created_at: :desc)
    end

    @posts.each do |post|
      impressionist(post, nil, unique: [:session_hash, :user_id])
    end
  end

  def dashboard
    @user = current_user
    @published_posts = current_user.posts.published
    @draft_posts = current_user.posts.draft
    @unpublished_posts = current_user.posts.unpublished
  end

  def new
    @post = Post.new
  end

  def create
    @user = current_user
    @post = Post.new(post_params)
    @post.user_id = @user.id

    if params[:commit] == "下書き保存"
      @post.status = :draft
    else
      @post.status = :published
    end
  
    if @post.save!
      if @post.draft?
        redirect_to dashboard_posts_path, notice: '下書きが保存されました。'
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
    @user = User.find_by(params[:account])
  end

  def edit
    @post = Post.find(params[:id])
    # @isdraft = is_draft?
    @user = current_user
  end

  def update
    @user = current_user
    @post = Post.find(params[:id])

    if @post.update(post_params)
      tag_list = params[:post][:tag_list].split(',').map(&:strip)
      @post.tag_list = tag_list

      case params[:commit]
      when "下書き保存"
        @post.update(status: :draft)
        redirect_to dashboard_posts_path, notice: "下書きを保存しました。"
      when "非公開にする"
        @post.update(status: :unpublished)
        redirect_to dashboard_posts_path, notice: "非公開にしました。"
      else
        @post.update(status: :published)
        redirect_to post_path(@post), notice: "投稿を更新しました。"
      end
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to dashboard_posts_path, notice: '投稿を削除しました。'
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

  # タグ検索
  def search_by_tag
    tag_name = params[:tag_name]
    @posts = Post.tagged_with(tag_name)
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

  #def autosave_params
  #  params.require(:post).permit(:title, :body, :link, :tag_list, :is_draft)
  #end

  def post_params
    params.require(:post).permit(:title, :content, :link, :tag_list, :status)
  end
end
