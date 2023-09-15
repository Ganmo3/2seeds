module ChannelBannerHelper
  include YoutubeHelper

  def youtube_banner_image_tag(channel_id, options = {})
    default_options = { size: 'default', alt: 'Channel Banner' }
    options = default_options.merge(options)

    banner_data = fetch_youtube_data(channel_id) do |service|
      channel_response = service.list_channels('snippet,brandingSettings', id: channel_id)
      channel_item = channel_response.items.first
      banner_url = case options[:size]
                   when 'default'
                     channel_item.branding_settings.image.banner_external_url
                   when 'medium'
                     channel_item.branding_settings.image.banner_medium_hd_image_url
                   when 'high'
                     channel_item.branding_settings.image.banner_external_url
                   else
                     channel_item.branding_settings.image.banner_external_url
                   end

      banner_url
    end

    image_tag(banner_data, alt: options[:alt], class: options[:class_name])
  end
end
