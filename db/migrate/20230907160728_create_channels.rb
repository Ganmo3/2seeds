class CreateChannels < ActiveRecord::Migration[6.1]
  def change
    create_table :channels do |t|
      t.string :channel_id, null: false
      t.string :channel_name
      t.string :channel_icon_url
      t.string :thumbnail_url
      t.string :video_title
      t.integer :view_count
      t.date :upload_date
      t.string :banner_image_url
      t.integer :user_id 
      t.integer :post_id 
      t.timestamps
    end
  end
end
