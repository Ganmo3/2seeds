class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :body, null: false
      t.string :link, null: false
      t.boolean :is_draft, default: false, null: false

      t.timestamps
    end
  end
end
