class RenameBodyToContentInPosts < ActiveRecord::Migration[6.1]
  def change
    rename_column :posts, :body, :content
  end
end
