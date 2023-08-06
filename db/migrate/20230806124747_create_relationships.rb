class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.integer :follower_id, class_name: "User", null: false
      t.integer :followed_id, class_name: "User", null: false

      t.timestamps
    end
  end
end
