module ChannelNameHelper
  def youtube_channel_name(channel_id)
    require 'google/apis/youtube_v3'

    # YouTube APIを使用してチャンネルの情報を取得
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = ENV['YOUTUBE_API_KEY']
    channel_response = service.list_channels('snippet', id: channel_id)
    channel_item = channel_response.items.first

    # チャンネル名を取得
    channel_name = channel_item.snippet.title if channel_item

    channel_name
  end
end
