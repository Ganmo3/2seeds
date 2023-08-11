class AddPostFavoriteAndCommentFavoriteToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_reference :notifications, :post_favorite, foreign_key: true
    add_reference :notifications, :comment_favorite, foreign_key: true
    
    remove_column :notifications, :favorite_id
  end
end
