module ApplicationHelper
  def extract_youtube_video_id(link)
    return nil if link.nil?
    
    uri = URI(link)
    query = URI.decode_www_form(uri.query)
    query_hash = Hash[query]
    query_hash["v"]
  end
end
