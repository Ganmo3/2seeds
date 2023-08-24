module ThumbnailHelper
  def youtube_thumbnail(video_id, options = {})
    require 'google/apis/youtube_v3'

    options = { show_info: true }.merge(options)

    # キャッシュの設定を変更する
    video_item = Rails.cache.fetch("youtube_thumbnail_#{video_id}", expires_in: 1.day) do
      service = Google::Apis::YoutubeV3::YouTubeService.new
      service.key = ENV['YOUTUBE_API_KEY']

      # ビデオの詳細情報（snippet, statistics）を取得
      video_response = service.list_videos('snippet,statistics', id: video_id)
      video_response.items.first
    end

    if video_item
      thumbnail_url = video_item.snippet.thumbnails.maxres.url
      title = video_item.snippet.title
      view_count = video_item.statistics&.view_count || 'N/A'  # nil の場合に 'N/A' をセット
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
    else
      # ビデオが見つからない場合の処理
      content_tag(:div, "Video not found", class: 'text-center')
    end
  end
end
