FactoryBot.define do
  factory :post do
    title { Faker::Lorem.characters(number: 20) }
    link { "https://www.youtube.com/watch?v=#{Faker::Alphanumeric.alpha(number: 11)}" } # ランダムなYouTubeリンクを生成
    user
    body { ActionText::Content.new(Faker::Lorem.paragraphs.join("\n")) }
    status { "published" } # デフォルトのステータスを設定

    factory :draft_post do
      status { "draft" }
      link { "https://www.youtube.com/watch?v=#{Faker::Alphanumeric.alpha(number: 11)}" }
    end

    factory :unpublished_post do
      status { "unpublished" }
      link { "https://www.youtube.com/watch?v=#{Faker::Alphanumeric.alpha(number: 11)}" }
    end
  end
end
