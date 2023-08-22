class Public::HomesController < ApplicationController
  def top
 #   @tags = Post.tag_counts_on(:tags).omst_used(20) # タグ一覧表示

    # 本日のデイリーいいね数の多い順に投稿を取得するクエリ
    today = Date.today
    @daily_popular_posts = Post.all.sort_by { |post| post.daily_likes_count(Date.today) }.reverse.take(5)
    
    # デイリーで一番視聴数が多い投稿を取得
    @daily_most_viewed_post = Post.all.max_by { |post| post.daily_views_count(today) }
    
    # 新規ユーザーや成長中のユーザーを含むランキングを算出
    @ranking = User.all.sort_by { |user| calculate_score(user) }.reverse.take(3)
    
    # 本日の新着投稿を取得
    @daily_new_posts = Post.order(created_at: :desc).take(5)

    @user = User.find_by(params[:account]) 

  end

  def about
  end
  
  private
  
  def calculate_score(user)
    # 評価スコアを計算するロジックを実装
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
