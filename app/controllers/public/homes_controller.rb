class Public::HomesController < ApplicationController
  def top
 #   @tags = Post.tag_counts_on(:tags).omst_used(20) # タグ一覧表示

    # 本日のデイリーいいね数の多い順に投稿を取得
    today = Date.today
    start_of_week = today.beginning_of_week(:sunday) # 週の開始日
    end_of_week = today.end_of_week(:sunday) # 週の終了日

    @daily_popular_posts = Post.all.sort_by { |post| post.daily_likes_count(Date.today) }.reverse.take(5)

    # 視聴回数順の投稿を取得
    @weekly_most_viewed_posts = Post.order(impressions_count: :desc)
                                .select { |post| post.impressionist_count(filter: :all, start_date: start_of_week, end_date: end_of_week) }
                                .take(3)


    # デイリーで一番視聴数が多い投稿を取得
    @daily_best = Post.all.max_by { |post| post.impressionist_count(filter: :all, start_date: Time.zone.now.beginning_of_day, end_date: Time.zone.now.end_of_day) }
    # 新規ユーザーや成長中のユーザーを含むランキングを算出
    @ranking = User.where.not(account: "guest").sort_by { |user| calculate_score(user) }.reverse.take(3)

    # 新着投稿を取得
    @daily_new_posts = Post.order(created_at: :desc).take(5)
  end

  def about
  end

  private

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
end
