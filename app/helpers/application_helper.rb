module ApplicationHelper
  def extract_youtube_video_id(link)
    return nil if link.nil?
    
    uri = URI(link)
    query = URI.decode_www_form(uri.query || '')
    query_hash = Hash[query]
    query_hash["v"] || nil
  end
  
  def extract_youtube_channel_id(url)
    if url =~ %r{https?://(?:www\.)?youtube\.com/channel/([^/]+)}
      $1
    elsif url =~ %r{https?://(?:www\.)?youtube\.com/user/([^/]+)}
      response = Net::HTTP.get(URI.parse(url))
      if match = response.match(%r{"externalChannelId":"([^"]+)"})
        match[1]
      end
    end
  end
  
  def user_icon_or_youtube(channel, options = {})
    default_size = options.fetch(:default_size, '40x40')
    size = options.fetch(:size, default_size)
    class_name = options.fetch(:class, 'rounded-circle')

    channel_id = extract_youtube_channel_id(channel)
    
    if channel_id.present?
      youtube_channel_icon(channel_id, size: size, class: class_name)
    else
      image_tag @user.get_icon, size: size, class: class_name
    end
  end

  
  
  def formatted_datetime(datetime)
    datetime.strftime('%Y/%m/%d')
  end
  
end
