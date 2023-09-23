class SearchesController < ApplicationController
  def search
  end

  def search_results
    @content = params[:content]
    @model = params[:model] || "nil"
    @method = params[:method]

    if @content.blank?
      flash.now[:error] = "検索ワードを入力してください。"
      render "searches/search"
      return
    end

    if @model == "post"
      @results = Post.tagged_with(@content)
    elsif @model == "tag"
      @results = ActsAsTaggableOn::Tag.named_like(@content).order(:name)
    end

    # Array
    @results = Search.search_all_models(@content, @model, @method)
    @results = @results.order(created_at: :desc).page(params[:page]).per(12)
    @total_results_count = @results.total_count


    render "searches/search_results"
  end
end
