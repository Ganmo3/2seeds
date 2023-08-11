class RemoveCommentIdFromPostFavorites < ActiveRecord::Migration[6.1]
  def change
    remove_column :post_favorites, :comment_id
  end
end
