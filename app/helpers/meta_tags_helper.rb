module MetaTagsHelper
  def default_meta_tags
    {
      site: "Seeding Success, Growing Influence",
      title: "2Seeds",
      reverse: true,
      charset: "utf-8",
      description: "2Seedsは動画クリエイターが自身の動画コンテンツのリンクと共に記事を公開できるブログサイト",
      keywords: "Youtuber,ブログ,ビデオ制作,コンテンツ制作",
      canonical: request.original_url,
      separator: "|",
      icon: [
        { href: image_url("favicon.png"), sizes: "60x60" },
        { href: image_url("favicon_ios.png"), rel: "apple-touch-icon", sizes: "90x90", type: "image/png" },
      ],
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: request.original_url,
        image: image_url("logo_2seeds.png"),
        local: "ja-JP",
      },
      twitter: {
        card: "summary_large_image",
        site: "@ganmo3mo",
        image: image_url("logo_2seeds.png"),
      },
    }
  end
end
