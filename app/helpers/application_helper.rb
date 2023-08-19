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
  
  def formatted_datetime(datetime)
    datetime.strftime('%Y/%m/%d')
  end
  
end
