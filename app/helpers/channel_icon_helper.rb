module ChannelIconHelper
  def youtube_channel_icon(channel_id, options = {})
    require 'google/apis/youtube_v3'

    # オプションをデフォルト値とマージ
    options = { size: 'default', alt: 'Channel Icon' }.merge(options)

    # YouTube APIを使用してチャンネルの情報を取得
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = ENV['YOUTUBE_API_KEY']
    channel_response = service.list_channels('snippet', id: channel_id)
    channel_item = channel_response.items.first

    # チャンネルのアイコンURLを取得
    channel_icon_url = case options[:size]
                       when 'default'
                         channel_item.snippet.thumbnails.default.url
                       when 'medium'
                         channel_item.snippet.thumbnails.medium.url
                       when 'high'
                         channel_item.snippet.thumbnails.high.url
                       else
                         channel_item.snippet.thumbnails.default.url
                       end

    # アイコンの画像タグを生成して返す
    image_tag(channel_icon_url, options)
  end
end
