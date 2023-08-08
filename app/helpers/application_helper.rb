module ApplicationHelper
    def extract_youtube_video_id(link)
    uri = URI(link)
    query = URI.decode_www_form(uri.query)
    query_hash = Hash[query]
    query_hash["v"]
  end
end
