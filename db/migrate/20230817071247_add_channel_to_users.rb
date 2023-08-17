class AddChannelToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :channel, :string
  end
end
