module ChannelNameHelper
  def youtube_channel_name(channel_id)
    # キャッシュのキーを生成
    cache_key = "youtube_channel_name_#{channel_id}"

    # キャッシュが存在する場合はそれを返す
    cached_name = Rails.cache.read(cache_key)
    return cached_name if cached_name

    require 'google/apis/youtube_v3'

    # YouTube APIを使用してチャンネルの情報を取得
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = ENV['YOUTUBE_API_KEY']
    channel_response = service.list_channels('snippet', id: channel_id)
    channel_item = channel_response.items.first

    # チャンネル名を取得
    channel_name = channel_item.snippet.title if channel_item

    # 取得したチャンネル名をキャッシュに保存し、期限を7日に設定
    Rails.cache.write(cache_key, channel_name, expires_in: 7.days)

    channel_name
  end
end
