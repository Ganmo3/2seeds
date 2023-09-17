class Public::TagsController < ApplicationController

  def show
    @tags = Post.tag_counts_on(:tags).order('count DESC')
     # パラメータからタグ名を取得
    tag_name = params[:id]
    # タグ名に基づいてタグに関連する情報を取得（例：タグが付けられた投稿）
    @tag = ActsAsTaggableOn::Tag.find_by(name: tag_name)
    @tagged_posts = Post.tagged_with(tag_name).page(params[:page]).per(12)

    # タグの一覧ページを表示するビューテンプレートをレンダリング
    render 'show'
  end
end
