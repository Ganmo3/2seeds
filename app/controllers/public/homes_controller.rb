class Public::HomesController < ApplicationController
  def top
    @daily_popular_posts = daily_popular_posts(5)
    @weekly_most_viewed_posts = weekly_most_viewed_posts(3)
    @daily_best = find_daily_best
    @ranking = calculate_ranking(3)
    @daily_new_posts = find_daily_new_posts(5)
  end

  def about
  end

  private

  def daily_popular_posts(limit)
    start_date = 3.days.ago.to_date
    end_date = Date.today
    posts = Post.published.where('created_at >= ? AND created_at <= ?', start_date, end_date)
                    .sort_by { |post| post.daily_likes_count(start_date, end_date) }
                    .reverse
    posts.take(limit)
  end

  def weekly_most_viewed_posts(limit)
    today = Date.today
    start_of_week = today.beginning_of_week(:sunday)
    end_of_week = today.end_of_week(:sunday)
    Post.published.order(impressions_count: :desc)
        .joins(:impressions)
        .where(impressions: { created_at: start_of_week..end_of_week })
        .group('posts.id')
        .order('COUNT(impressions.id) DESC')
        .limit(limit)
  end

  def find_daily_best
    yesterday = Date.yesterday
    start_of_day_yesterday = yesterday.beginning_of_day
    end_of_day_yesterday = yesterday.end_of_day
  
    # 昨日の中で視聴回数が最も多い投稿を取得
    yesterday_best = Post.published
                         .where('created_at <= ?', end_of_day_yesterday)
                         .order(impressions_count: :desc)
                         .first
  
    # 昨日のベスト投稿が存在しない場合、今日の中で視聴回数が最も多い投稿を取得
    if yesterday_best.nil?
      today = Date.today
      start_of_day_today = today.beginning_of_day
      end_of_day_today = today.end_of_day
  
      today_best = Post.published
                       .where('created_at <= ?', end_of_day_today)
                       .order(impressions_count: :desc)
                       .first
      return today_best
    end
  
    yesterday_best
  end

  def calculate_ranking(limit)
    User.where(status: 0).where.not(account: "guest").sort_by { |user| calculate_score(user) }.reverse.take(limit)
  end

  def calculate_score(user)
    # 評価スコアを計算するロジック
    views_score = user.weekly_views_count * 0.5
    likes_score = user.weekly_likes_count * 0.3
    comments_score = user.weekly_comments_count * 0.2
    total_score = views_score + likes_score + comments_score

    # 新規ユーザーへのボーナスを付与（例：登録から1週間以内）
    if user.created_at >= 1.week.ago
      total_score += 100
    end

    total_score
  end

  def find_daily_new_posts(limit)
    Post.where(status: :published).order(created_at: :desc).take(limit)
  end
end
