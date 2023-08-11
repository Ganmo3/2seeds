class CreateCommentFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :comment_favorites do |t|
      t.references :user, foreign_key: true, null: false
      t.references :comment, foreign_key: true, null: false

      t.timestamps
    end
  end
end
