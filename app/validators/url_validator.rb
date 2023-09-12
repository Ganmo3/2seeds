class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    
    # value が nil の場合はバリデーションをスキップ
    return if value.nil?
    
    unless valid_url?(value)
      record.errors[attribute] << (options[:message] || "is not a valid URL")
    end
  end

  private

  def valid_url?(url)
    # URLがHTTPまたはHTTPSスキームで始まることをチェックする正規表現
    url_regex = /\A(http|https):\/\/[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-]+\z/
    
    # URLが正しい形式かどうかをチェック
    if url.match?(url_regex)
      return true
    else
      return false
    end
  end
end
