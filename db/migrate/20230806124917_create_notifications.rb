class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :visitor, null: false, foreign_key: { to_table: :users }
      t.references :visited, null: false, foreign_key: { to_table: :users }
      t.references :post, foreign_key: true
      t.references :comment, foreign_key: true
      t.references :post_favorite, foreign_key: true
      t.references :comment_favorite, foreign_key: true
      t.references :relationship, foreign_key: true
      t.string :action, null: false, default: ''
      t.boolean :is_checked, null: false, default: false

      t.timestamps
    end
  end
end
