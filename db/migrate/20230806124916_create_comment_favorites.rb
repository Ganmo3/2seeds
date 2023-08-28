class CreateCommentFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :comment_favorites do |t|
      t.integer :user_id, null: false
      t.integer :comment_id, null: false

      t.timestamps
    end
  end
end
