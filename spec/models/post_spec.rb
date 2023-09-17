# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Post, type: :model do
  subject { post.valid? }

  # Factoryでデータを作る
  let(:user) { create(:user) }
  let(:post) { build(:post, user_id: user.id) }

  it "テスト用のUserやPostが存在するか（Factoryでちゃんと作られたか確認)" do
    expect(user).to be_valid
    expect(post).to be_valid
  end

  context "titleカラム" do
    it "空欄でないこと" do
      is_expected.to eq true
    end
  end

  context "with an invalid link" do
    let(:post) { build(:post, user_id: user.id, link: "https://example.com") }

    it "リンクが無効な場合に投稿できないこと" do
      is_expected.to eq false
    end
  end
end
