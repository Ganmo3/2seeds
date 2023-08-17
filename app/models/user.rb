class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  # email or accountでのログイン設定
  # attr_accessor :login

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
    existing_notification = Notification.find_by(visitor_id: current_user.id, visited_id: id, action: 'follow')
  
    # フォロー通知が存在しない場合のみ、通知レコードを作成
    if existing_notification.blank?
      notification = current_user.active_notifications.build(
        visited_id: id,
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

  # idの代わりにアカウントを使用
  def to_param
    account
  end
  
  # 英数字（小文字）と"-" "_"のみ許可
  validates :account,
    format: { with: /\A[a-z0-9_-]+\z/ },
    length: { minimum: 3, maximum: 25 }
  
  # 会員ステータス
  enum status: { active: 0, banned: 1, inactive: 2 }

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
  
  
end