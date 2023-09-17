# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  subject { user.valid? }

  let(:user) { build(:user) } # FactoryBotを使用してUserインスタンスを作成

  describe 'validations' do
    context 'nicknameカラム' do
      it '空欄でないこと' do
        user.nickname = ''
        is_expected.to eq false
      end

      it '2文字以上であること: 1文字は×' do
        user.nickname = Faker::Lorem.characters(number: 1)
        is_expected.to eq false
      end

      it '2文字以上であること: 2文字は〇' do
        user.nickname = Faker::Lorem.characters(number: 2)
        is_expected.to eq true
      end

      it '20文字以下であること: 21文字は×' do
        user.nickname = Faker::Lorem.characters(number: 21)
        is_expected.to eq false
      end

      it '20文字以下であること: 20文字は〇' do
        user.nickname = Faker::Lorem.characters(number: 20)
        is_expected.to eq true
      end
    end

    context 'accountカラム' do
      it '空欄でないこと' do
        user.account = ''
        is_expected.to eq false
      end

      it '3文字以上であること: 2文字は×' do
        user.account = Faker::Lorem.characters(number: 2)
        is_expected.to eq false
      end

      it '3文字以上であること: 3文字は〇' do
        user.account = Faker::Lorem.characters(number: 3)
        is_expected.to eq true
      end

      it '20文字以下であること: 21文字は×' do
        user.account = Faker::Lorem.characters(number: 21)
        is_expected.to eq false
      end

      it '20文字以下であること: 20文字は〇' do
        user.account = Faker::Lorem.characters(number: 20)
        is_expected.to eq true
      end

      it '正しいフォーマットであること: 数字とアルファベット、ハイフン、アンダースコアが許可される' do
        valid_accounts = ['user123', 'user-name', 'user_name']
        invalid_accounts = ['user@123', 'user.name', 'user$name']

        valid_accounts.each do |account|
          user.account = account
          expect(user).to be_valid
        end

        invalid_accounts.each do |account|
          user.account = account
          expect(user).not_to be_valid
        end
      end
    end


    context 'emailカラム' do
      it '空欄でないこと' do
        user.email = ''
        is_expected.to eq false
      end

      it '有効なメールアドレスの形式であること' do
        valid_emails = ['user@example.com', 'john.doe@gmail.com', 'test_user123@example.co.uk']
        invalid_emails = ['invalid_email', 'user@.com', 'user@example']

        valid_emails.each do |email|
          user.email = email
          expect(user).to be_valid
        end

        invalid_emails.each do |email|
          user.email = email
          expect(user).not_to be_valid
        end
      end
    end

    context 'channelカラム' do
      it '正しいYouTubeチャンネルのURL形式であること' do
        user.channel = 'https://www.youtube.com/channel/CHANNEL_ID'
        is_expected.to eq true
      end

      it '正しくないYouTubeチャンネルのURL形式であること' do
        user.channel = 'https://example.com'
        is_expected.to eq false
      end
    end

    context 'active_for_authentication?' do
      it 'activeステータスのユーザーはログインできること' do
        user.status = 'active'
        expect(user.active_for_authentication?).to eq true
      end

      it 'bannedステータスのユーザーはログインできないこと' do
        user.status = 'banned'
        expect(user.active_for_authentication?).to eq false
      end

      it 'inactiveステータスのユーザーはログインできないこと' do
        user.status = 'inactive'
        expect(user.active_for_authentication?).to eq false
      end
    end

  end
end
