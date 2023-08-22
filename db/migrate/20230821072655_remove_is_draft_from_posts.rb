class RemoveIsDraftFromPosts < ActiveRecord::Migration[6.1]
  def up
    Post.reset_column_information

    # 既存のデータを変換
    Post.find_each do |post|
      if post.is_draft
        post.update(status: Post.statuses[:draft])
      else
        post.update(status: Post.statuses[:published])
      end
    end

    remove_column :posts, :is_draft
  end

  def down
    add_column :posts, :is_draft, :boolean

    Post.reset_column_information

    # 既存のデータを変換
    Post.find_each do |post|
      if post.status == 'draft'
        post.update(is_draft: true)
      else
        post.update(is_draft: false)
      end
    end
  end
end