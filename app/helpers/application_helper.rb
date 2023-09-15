module ApplicationHelper
  def extract_youtube_video_id(link)
    return nil if link.nil?

    uri = URI(link)
    query = URI.decode_www_form(uri.query || '')
    query_hash = Hash[query]

    video_id = query_hash["v"]

    # ショートビデオID形式の対応
    if video_id.nil?
      path = uri.path
      video_id = path.split('/').last if path.present? && path != '/'
    end

    video_id
  end

  def extract_youtube_channel_id(url)
    if url =~ %r{https?://(?:www\.)?youtube\.com/channel/([^/]+)}
      $1
    elsif url =~ %r{https?://(?:www\.)?youtube\.com/user/([^/]+)}
      response = Net::HTTP.get(URI.parse(url))
      if match = response.match(%r{"externalChannelId":"([^"]+)"})
        match[1]
      else
        nil  # チャンネル ID を取得できない場合は nil を返す
      end
    else
      nil  # 対応する URL パターンが見つからない場合も nil を返す
    end
  end

  def user_icon_or_youtube(user, options = {})
    default_size = options.fetch(:default_size, '40x40')
    size = options.fetch(:size, default_size)
    class_name = options.fetch(:class, 'rounded-circle')
  
    channel_id = extract_youtube_channel_id(user.channel)
  
    if channel_id.present?
      youtube_channel_icon(channel_id, size: size, class: class_name)
    else
      image_tag(user.get_icon, size: size, class: class_name)
    end
  end


  def formatted_datetime(datetime)
    datetime.strftime('%Y/%m/%d')
  end
  
  
  def user_banner_or_default(user, options = {})
    default_banner = options.fetch(:default_banner, 'user-show.jpg')
    class_name = options.fetch(:class, '')

    channel_id = extract_youtube_channel_id(user.channel)

    if channel_id.present?
      begin
        # エラーが発生する可能性がある処理をbegin-endブロックで囲む
        youtube_banner_image_tag(channel_id, size: options[:size] || 'default', alt: 'Channel Banner', class: class_name)
      rescue NoMethodError
        # エラーが発生した場合、デフォルトのバナー画像を表示
        image_tag(default_banner, class: class_name)
      end
    else
      # チャンネルIDがない場合もデフォルトのバナー画像を表示
      image_tag(default_banner, class: class_name)
    end
  end

end
