class Post < ApplicationRecord
  # gem:impressionableの使用
  is_impressionable counter_cache: true, column_name: :impressions_count

  # gem:acts_as_taggableの使用
  acts_as_taggable_on :tags

  # action textの使用
  has_rich_text :body

  belongs_to :user
  has_many :post_favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # バリデーションの設定
  validates :title, presence: true
  validates :link, presence: true, format: { with: %r{\Ahttps?://(?:www\.)?youtube\.com/(?:watch\?v=|embed/|shorts/|v/)([\w-]{11})\z}i,
                                              message: "はYouTubeの正しい動画リンクである必要があります" }
  validates :body, presence: true, unless: -> { body.present? }

  # 投稿ステータス
  enum status: { published: 0, draft: 1,  unpublished: 2 }


  # いいね機能
  def favorited_by?(user)
    user.present? && post_favorites.exists?(user_id: user.id)
  end

  # 3日間のいいね数のカウント
  def daily_likes_count(start_date, end_date)
    post_favorites.where("created_at >= ? AND created_at < ?", start_date.beginning_of_day, end_date.end_of_day).count
  end
  
  # いいねの数をカウント
  def likes_count
    Post.includes(:post_favorites)
        .group('posts.id')
        .order('COUNT(post_favorites.id) DESC')
  end

  # デイリー視聴回数のカウント
  def daily_views_count(date)
    impressions.where("created_at >= ? AND created_at < ?", date.beginning_of_day, date.end_of_day).count
  end

  #　検索用
  def self.search_content(content, method)
    if method == "perfect"
      where(title: content)
    elsif method == "partial"
      where("title LIKE ?", "%#{content}%")
    else
      all
    end
  end

  # postへのいいね通知機能
def create_notification_favorite_post!(current_user, user_id, id)
  # すでに「いいね」されているかを検索
  existing_notification = Notification.find_by(visitor_id: current_user.id, visited_id: user_id, post_id: id, action: "favorite_post")

  # いいねされていない場合のみ、通知レコード作成
  if existing_notification.nil?
    notification = current_user.active_notifications.build(
      post_id: id,
      visited_id: user_id,
      action: "favorite_post"
    )

    # 自分の投稿に対するいいねの場合は、通知済みとする
    notification.is_checked = true if notification.visitor_id == notification.visited_id

    if notification.valid?
      notification.save
      # 通知の履歴を残すために通知を保存
      notification.reload
    end
  end
end


  # commentへのいいね通知機能
  def create_notification_favorite_comment!(current_user, comment_id)
    # すでに「いいね」されている検索
    existing_notification = Notification.find_by(visitor_id: current_user.id, visited_id: @comment.user_id, comment_id: comment_id, action: "favorite_comment")
    # いいねされていない場合のみ、通知レコード作成
    if existing_notification.blank?
      notification = current_user.active_notifications.new(
        comment_id: comment_id,
        visited_id: comment.user_id,
        action: "favorite_comment"
      )
      # 自分のコメントに対するいいねの場合は、通知済みとする
      notification.is_checked = true if notification.visitor_id == notification.visited_id

      if notification.valid?
        notification.save
        # 通知の履歴を残すために通知を保存
        notification.reload
      end
    end
  end


  # コメントが投稿された際に通知を作成するメソッド
  def create_notification_comment!(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    other_commenters_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct.pluck(:user_id)

    # 各コメントユーザーに対して通知を作成
    other_commenters_ids.each do |commenter_id|
      save_notification_comment!(current_user, comment_id, commenter_id)
    end

    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, comment_id, user_id) if other_commenters_ids.blank?
  end

  # 通知を保存するメソッド
  def save_notification_comment!(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.build(
      post_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )

    # 自分の投稿に対するコメントの場合は、通知済みとする
    notification.is_checked = true if notification.visitor_id == notification.visited_id

    # 通知を保存（バリデーションが成功する場合のみ）
    notification.save if notification.valid?
  end


  # 3日間でいいねが多い投稿を取得
  def self.daily_popular_posts(limit)
    start_date = 3.days.ago.to_date
    end_date = Date.today
  
    # 3日間でいいねが多い順にソートされた投稿を取得
    posts_within_period = published
      .joins(:post_favorites) # いいねのある投稿のみを取得するためにJOIN
      .where('posts.created_at >= ? AND posts.created_at <= ?', start_date, end_date)
      .group('posts.id')
      .order('COUNT(post_favorites.id) DESC')
  
    # もし5件未満の場合、期間に関係なくいいねが多い順で追加の投稿を取得
    if posts_within_period.length < limit
      additional_posts = published
        .joins(:post_favorites) # いいねのある投稿のみを取得するためにJOIN
        .where.not(id: posts_within_period.map(&:id)) # すでに取得した投稿を除外
        .group('posts.id')
        .order('COUNT(post_favorites.id) DESC')
        .limit(limit - posts_within_period.length) # 不足分を取得
  
      posts_within_period += additional_posts
    end
  
    # 最終的な結果をlimitの数だけ返す
    posts_within_period.take(limit)
  end

  # 1週間でPVが多い投稿を取得
  def self.weekly_most_viewed_posts(limit)
    today = Date.today
    start_of_week = today.beginning_of_week(:sunday)
    end_of_week = today.end_of_week(:sunday)
    published.order(impressions_count: :desc)
        .joins(:impressions)
        .where(impressions: { created_at: start_of_week..end_of_week })
        .group('posts.id')
        .order('COUNT(impressions.id) DESC')
        .limit(limit)
  end

  # デイリーベスト投稿を取得するためのメソッド
  def self.find_daily_best
    yesterday = Date.yesterday
    start_of_day_yesterday = yesterday.beginning_of_day
    end_of_day_yesterday = yesterday.end_of_day

    # 昨日の中で視聴回数が最も多い投稿を取得
    yesterday_best = published
                         .where('created_at <= ?', end_of_day_yesterday)
                         .order(impressions_count: :desc)
                         .first

    # 昨日のベスト投稿が存在しない場合、今日の中で視聴回数が最も多い投稿を取得
    if yesterday_best.nil?
      today = Date.today
      start_of_day_today = today.beginning_of_day
      end_of_day_today = today.end_of_day

      today_best = published
                       .where('created_at <= ?', end_of_day_today)
                       .order(impressions_count: :desc)
                       .first
      return today_best
    end

    yesterday_best
  end

  # 最新の投稿を取得
  def self.find_daily_new_posts(limit)
    published.order(created_at: :desc).take(limit)
  end

  # 投稿のいいね数ソート
  def self.sort_by_favorites
    left_joins(:post_favorites)
      .group(:id)
      .order('COUNT(post_favorites.id) DESC')
  end
  
  # 投稿のPV数順
  def self.sort_by_impressions_count
    published
      .order(impressions_count: :desc)
  end
  
  # published_post全体の合計表示回数
  def self.total_impressions_count
    where(status: 'published').sum(:impressions_count)
  end
  

  # publishedステータスの投稿新着ソート
  def self.published_posts
    where(status: 'published').order(created_at: :desc)
  end
  
  # いいねをつけた投稿の取得
  def self.liked_posts(user, page, per_page)
  includes(:post_favorites)
    .where(post_favorites: { user_id: user.id })
    .order(created_at: :desc)
    .page(page)
    .per(per_page)
  end

end