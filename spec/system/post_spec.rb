# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "Associations" do
    it "belongs to a user" do
      # PostモデルはUserモデルに属していることをテストしています。
      post_association = described_class.reflect_on_association(:user)
      expect(post_association.macro).to eq(:belongs_to)
    end

    it "has many post comments" do
      # PostモデルはPostCommentモデルと多対多の関連性を持つことをテストしています。
      post_association = described_class.reflect_on_association(:post_comments)
      expect(post_association.macro).to eq(:has_many)
    end
  end

  describe "Instance methods" do
    describe "#save_draft" do
      it "saves the post as draft" do
        # #save_draft メソッドが投稿をドラフトとして保存することをテストしています。
        post = create(:post, status: :published)
        post.save_draft
        expect(post.reload.post_status).to eq("draft")
      end
    end
  end

  describe "Scopes" do
    describe ".published" do
      it "returns published posts" do
        # .published スコープが公開された投稿のみを返すことをテストしています。
        published_post = create(:post, status: :published)
        draft_post = create(:post, status: :draft)

        expect(described_class.published).to eq([published_post])
      end
    end

    describe ".by_active_users" do
      it "returns posts by active users" do
        # .by_active_users スコープがアクティブなユーザーによって投稿された投稿のみを返すことをテストしています。
        active_user = create(:user, status: 0)
        inactive_user = create(:user, status: 1)
        active_user_post = create(:post, user: active_user)
        inactive_user_post = create(:post, user: inactive_user)

        expect(described_class.by_active_users).to eq([active_user_post])
      end
    end

    describe ".visible" do
      it "returns visible posts" do
        # .visible スコープが表示可能な投稿のみを返すことをテストしています。
        visible_post = create(:post, status: :published, user: create(:user, status: 0))
        invisible_post1 = create(:post, status: :draft, user: create(:user, status: 0))
        invisible_post2 = create(:post, status: :published, user: create(:user, status: 1))

        expect(described_class.visible).to eq([visible_post])
      end
    end
  end
end
