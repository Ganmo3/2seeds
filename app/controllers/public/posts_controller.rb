class Public::PostsController < ApplicationController
  before_action :hide_header, only: [:new, :edit]
  before_action :hide_footer, only: [:new, :edit]
  before_action :authenticate_user!, except: [:index, :trending, :weekly_ranking, :show, :search_by_tag]

  def index
    case params[:sort]
    when 'favorites'
      @posts = Post.sort_by_favorites.page(params[:page]).per(12)
    when 'impressions_count'
      @posts = Post.sort_by_impressions_count.page(params[:page]).per(12)
    else
      @posts = Post.published.order(created_at: :desc).page(params[:page]).per(12)
    end
  
    @posts.each do |post|
      impressionist(post, nil, unique: [:session_hash, :user_id])
    end
  end


  def trending
    @trending_posts = Post.daily_popular_posts(18)
  end

  def weekly_ranking
    @weekly_ranking_posts = Post.weekly_most_viewed_posts(12)
  end

  def dashboard
    @user = current_user
    @published_posts = @user.posts.published.order(created_at: :desc).page(params[:published_page]).per(20)
    @draft_posts = @user.posts.draft.order(created_at: :desc).page(params[:draft_page]).per(20)
    @unpublished_posts = @user.posts.unpublished.order(created_at: :desc).page(params[:unpublished_page]).per(20)
  end

  def new
    @post = Post.new
  end

  def create
    @user = current_user
    @post = Post.new(post_params)
    @post.user_id = @user.id

    # if current_user.guest_user?
    #   if params[:draft].present?
    #     redirect_to dashboard_posts_path, notice: 'ゲストユーザーは下書き保存できません。'
    #   else
    #     redirect_to dashboard_posts_path, notice: 'ゲストユーザーは公開できません。'
    #   end
    # else
      if params[:draft].present?
        @post.status = :draft
      else
        @post.status = :published
      end

      if @post.save
        if @post.draft?
          redirect_to dashboard_posts_path, notice: '下書きが保存されました。'
        else
          redirect_to post_path(@post), notice: '投稿が公開されました。'
        end
      else
        render :new
      end
    # end
  end

  def show
    @post = Post.find(params[:id])
    impressionist(@post, nil, unique: [:session_hash]) # 同セッションでの重複閲覧をカウントしない
    @comment = Comment.new
    @comments = Comment.where(post_id: params[:id]).order(created_at: :desc)
    @tags = @post.tag_counts_on(:tags)
    @report = Report.new
    @user = @post.user
    @latest_posts = @user.posts.order(created_at: :desc).limit(4)
  end

  def edit
    @post = Post.find(params[:id])
    @user = current_user

    if user_signed_in? && @post.user != @user
     redirect_to root_path, alert: "編集権限がありません。"
    end
  end

  def update
    @user = current_user
    @post = Post.find(params[:id])
    tag_list = params[:post][:tag_list].split(',').map(&:strip)

    @post.assign_attributes(post_params)
    @post.tag_list = tag_list

    if params[:draft].present?
      @post.status = :draft
      notice_message = "下書きを保存しました。"
      redirect_path = dashboard_posts_path
    elsif params[:unpublished].present?
      @post.status = :unpublished
      notice_message = "非公開にしました。"
      redirect_path = dashboard_posts_path
    else
      @post.status = :published
      notice_message = "投稿を更新しました。"
      redirect_path = post_path(@post)
    end

    if @post.save
      redirect_to redirect_path, notice: notice_message
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
    @preview_post.user = current_user
    @preview_tags = @preview_post.tag_list.clone
    @preview_post.tag_list = []
    render partial: 'preview', locals: { post: @preview_post, preview_tags: @preview_tags }
  end

  def analytics
    @user = current_user
    @posts = @user.posts
    # 過去1ヶ月分のデイリーごとの総視聴回数データを取得
    @daily_impressions_data = calculate_daily_impressions

    respond_to do |format|
      format.html
      format.json { render json: @daily_impressions_data }
    end
  end

  # タグ検索
  def search_by_tag
    tag_name = params[:tag_name]
    @posts = Post.tagged_with(tag_name)
  end

  private

  # アナリティクスの計算
  def calculate_daily_impressions
    impressions = Impression.where(impressionable_type: 'Post', created_at: 1.month.ago..Time.now, impressionable_id: @user.posts.pluck(:id))
    daily_impressions_data = impressions.group("DATE(created_at)").count

    # 集計されたデータを日付ごとのハッシュ形式に整形
    daily_impressions_hash = {}
    impressions_date_range(1.month.ago.to_date, Date.today).each do |date|
      formatted_date = date.to_s(:db) # "2023-09-01" のような形式に変換
      daily_impressions_hash[formatted_date] = daily_impressions_data[formatted_date].to_i
    end

    daily_impressions_hash
  end

  # 指定した期間内の日付範囲を取得
  def impressions_date_range(start_date, end_date)
    (start_date..end_date).to_a
  end


  def hide_header
    @show_header = false
  end
  
  def hide_footer
    @show_footer = false
  end


  def post_params
    params.require(:post).permit(:title, :body, :link, :tag_list, :status)
  end
end
