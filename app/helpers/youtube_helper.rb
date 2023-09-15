module YoutubeHelper
  def fetch_youtube_data(id, expires_in = 7.days)
    # キャッシュからデータを取得
    cache_key = "youtube_data_#{id}"
    cached_data = Rails.cache.read(cache_key)
    return cached_data if cached_data

    require 'google/apis/youtube_v3'

    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = ENV['YOUTUBE_API_KEY']

    data = yield(service)

    # データをキャッシュに保存
    Rails.cache.write(cache_key, data, expires_in: expires_in)

    data
  end
end