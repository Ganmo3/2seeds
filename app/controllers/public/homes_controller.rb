class Public::HomesController < ApplicationController
  def top
    @daily_popular_posts = Post.daily_popular_posts(5)
    @weekly_most_viewed_posts = Post.weekly_most_viewed_posts(3)
    @daily_best = Post.find_daily_best
    @ranking = User.calculate_ranking(3)
    @daily_new_posts = Post.find_daily_new_posts(5)
  end

  def about
  end
end
