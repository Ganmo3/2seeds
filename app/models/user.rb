class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 投稿、いいね、コメントとのアソシエーション
  has_many :posts, dependent: :destroy
  has_many :post_favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :comment_favorites, dependent: :destroy

  # 通報
  has_many :reporter, class_name: "Report", foreign_key: "reporter_id", dependent: :destroy
  has_many :reported, class_name: "Report", foreign_key: "reported_id", dependent: :destroy

  # 通知
  has_many :active_notifications, class_name: "Notification", foreign_key: "visitor_id", dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy

  # フォロー機能
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy # フォローしている関連付け
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy # フォローされている関連付け

  has_many :followings, through: :active_relationships, source: :followed # フォローしているユーザーを取得
  has_many :followers, through: :passive_relationships, source: :follower # フォロワーを取得

  # バリデーションの設定
  # 英数字（小文字）と"-" "_"のみ許可
  validates :account, presence: true, format: { with: /\A[a-z0-9_-]+\z/ }, length: { minimum: 3, maximum: 20 }
  validates :nickname, presence: true, length: {minimum: 2, maximum: 20 }
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "は有効なメールアドレスの形式である必要があります" }
  validates :channel, format: { with: /\A\z|https?:\/\/(?:www\.)?youtube\.com\/channel\/[\w-]+\z/, message: "は正しいYouTubeチャンネルのURL形式ではありません" }

  # idの代わりにアカウントを使用
  def to_param
    account
  end

  # 会員が無効になったときのコールバック
  before_update :delete_related_data, if: :status_changed?

  # ゲストログイン機能
  GUEST_USER_EMAIL = "guest@2seeds.com"
  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.nickname = "guestuser"
      user.account = "guest"
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end

  # 人気クリエイターの計算メソッド
  def self.calculate_ranking(limit)
    where(status: 0).where.not(account: "guest").sort_by { |user| user.calculate_score }.reverse.take(limit)
  end

  def calculate_score
    # 評価スコアを計算するロジック
    views_score = weekly_views_count * 0.5
    likes_score = weekly_likes_count * 0.3
    comments_score = weekly_comments_count * 0.2
    total_score = views_score + likes_score + comments_score

    # 新規ユーザーへのボーナスを付与（登録から1週間以内）
    if created_at >= 1.week.ago
      total_score += 100
    end

    total_score
  end

  # 指定したユーザーをフォローする
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  # 指定したユーザーのフォローを解除する
  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  # 指定したユーザーをフォローしているかどうかを判定
  def following?(user)
    followings.include?(user)
  end

  # フォロー通知を作成するメソッド
  def create_notification_follow!(current_user)
    # すでにフォロー通知が存在するか検索

    existing_notification = Notification.find_by(visitor_id: current_user.id, visited_id: self.id, action: 'follow')

    # フォロー通知が存在しない場合のみ、通知レコードを作成
    if existing_notification.blank?
      notification = current_user.active_notifications.build(
        visited_id: self.id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  # ActiveStorage
  has_one_attached :icon

  def get_icon
    unless icon.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      icon.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    icon.variant(resize_to_limit: [100, 100]).processed
  end

  # 会員ステータス
  enum status: { active: 0, banned: 1, inactive: 2 }

  # active会員のみログインできる
  def active_for_authentication?
    super && (status == 'active')
  end

  # ランキングのためのカウント
  def weekly_views_count
    Rails.cache.fetch("user_#{id}_weekly_views_count") do
      weekly_posts = posts.where(created_at: 1.week.ago..Time.current)
      weekly_posts.inject(0) { |sum, post| sum + post.impressionist_count }
    end
  end

  def weekly_likes_count
    Rails.cache.fetch("user_#{id}_weekly_likes_count") do
      post_favorites.where(created_at: 1.week.ago..Time.current).count
    end
  end

  def weekly_comments_count
    Rails.cache.fetch("user_#{id}_weekly_comments_count") do
      comments.where(created_at: 1.week.ago..Time.current).count
    end
  end

  # 検索用
  def self.search_content(content, method)
    if method == "perfect"
      where("nickname = ?", content)
    elsif method == "partial"
      where("nickname LIKE ?", "%#{content}%")
    else
      all
    end
  end

  # 削除メソッド
  after_update :delete_related_data, if: :will_save_change_to_status?

  private

  # ステータスが退会になったときに対象のレコードを削除
  def delete_related_data
    if inactive?
      posts.destroy_all
      comments.destroy_all
      active_notifications.destroy_all
      passive_notifications.destroy_all
      active_relationships.destroy_all
      passive_relationships.destroy_all
    end
  end

end