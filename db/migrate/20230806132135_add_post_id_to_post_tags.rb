class AddPostIdToPostTags < ActiveRecord::Migration[6.1]
  def change
    add_reference :post_tags, :post, foreign_key: true
  end
end
