class ChangeColumnNameInNotifications < ActiveRecord::Migration[6.1]
  def change
    rename_column :notifications, :visiter_id, :visitor_id
  end
end
