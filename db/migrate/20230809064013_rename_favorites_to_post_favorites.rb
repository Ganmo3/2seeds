class RenameFavoritesToPostFavorites < ActiveRecord::Migration[6.1]
  def change
    rename_table :favorites, :post_favorites
  end
end
