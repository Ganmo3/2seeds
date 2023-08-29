class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id, null: false
      t.string :title, null: false
      t.string :link, null: false
      t.integer :status, default: 0, null: false
      t.integer :impressions_count, default: 0, null: false

      t.timestamps
    end
  end
end
