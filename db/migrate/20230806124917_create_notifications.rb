class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :visitor_id, null: false
      t.integer :visited_id, null: false
      t.integer :post_id
      t.integer :comment_id
      t.integer :post_favorite_id
      t.integer :comment_favorite_id
      t.integer :relationship_id
      t.string :action, null: false, default: ''
      t.boolean :is_checked, null: false, default: false

      t.timestamps
    end
  end
end
