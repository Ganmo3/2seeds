class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.references :reporter, null: false, foreign_key: { to_table: :users }
      t.references :reported, null: false, foreign_key: { to_table: :users }
      t.string :content_type, null: false
      t.references :content, null: false
      t.integer :reason, null: false

      t.timestamps
    end
  end
end
