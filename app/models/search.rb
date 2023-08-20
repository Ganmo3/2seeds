class Search < ApplicationRecord
  def self.search_all_models(content, model, method)
    if model.present?
      if model == "user"
        User.search_content(content, method)
      elsif model == "post"
        Post.search_content(content, method)
      elsif model == "tag"
        # タグの検索
        ActsAsTaggableOn::Tag.named_like(content)
      end
    else
      results = []
      results << User.search_content(content, method)
      results << Post.search_content(content, method)
      results << ActsAsTaggableOn::Tag.named_like(content)
      results.flatten
    end
  end
end
