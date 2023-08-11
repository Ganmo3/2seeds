module ThumbnailHelper
  def youtube_thumbnail(video_id, options = {})
    require 'google/apis/youtube_v3'
    
    options = { show_info: true }.merge(options)

    # キャッシュの設定を変更する
    Rails.cache.fetch("youtube_thumbnail_#{video_id}", expires_in: 1.day) do
      service = Google::Apis::YoutubeV3::YouTubeService.new
      service.key = ENV['YOUTUBE_API_KEY']

      # ビデオの詳細情報（snippet, statistics）を取得
      video_response = service.list_videos('snippet,statistics', id: video_id)
      video_item = video_response.items.first

      # サムネイル、タイトル、再生回数、アップロード日の取得
      thumbnail_url = video_item.snippet.thumbnails.maxres.url
      title = video_item.snippet.title
      view_count = video_item.statistics.view_count
      upload_date = video_item.snippet.published_at.to_date.strftime('%Y/%m/%d')
      
      content = content_tag(:div, class: 'text-center') do
        image_tag(thumbnail_url, alt: title, **options) +
        if options[:show_info]
          content_tag(:div, class: 'video-info') do
            content_tag(:p, raw("#{title}<br>#{number_with_delimiter(view_count)} views #{upload_date}"))
          end
        end
      end


      content
    end
  end
end
 