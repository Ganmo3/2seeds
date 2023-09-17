FactoryBot.define do
  factory :user do
    nickname { Faker::Lorem.characters(number: 10) }
    account { Faker::Lorem.characters(number: 10) }
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }

    # 正しいYouTubeチャンネルのURL形式
    channel { "https://www.youtube.com/channel/CHANNEL_ID" }

    factory :user_with_invalid_channel do
      # 正しくないYouTubeチャンネルのURL形式
      channel { "https://example.com" }
    end
  end
end
