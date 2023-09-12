# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create(
  email: ENV['ADMIN_EMAIL'],
  password: ENV['ADMIN_PASSWORD']
)

# タグの作成
tags = %w(旅行 料理 音楽 スポーツ アート)
tags.each { |tag_name| ActsAsTaggableOn::Tag.find_or_create_by(name: tag_name) }

# ユーザーアカウントとニックネームの配列
nicknames = ['がんも', 'だいこん', 'たまご', 'はんぺん', '牛すじ']

# ユーザー作成メソッド
def create_user(account, nickname, tags)
  introduction = "よろしくお願いします、#{nickname}です。YouTubeチャンネルを登録するとYouTubeのチャンネルアイコンに変わります。"
  email = "#{account}@2seeds.com"
  password = "123456"
  channel = "https://www.youtube.com/channel/UCUfZCxi6GBN4fam5kiwPUnA"
  status = 0

  # ランダムな日付を生成
  min_days_ago = 1
  max_days_ago = 365
  random_days_ago = rand(min_days_ago..max_days_ago)
  random_date = Time.now - random_days_ago.days

  user_params = {
    account: account,
    nickname: nickname,
    email: email,
    password: password,
    introduction: introduction,
    channel: channel,
    status: status,
    created_at: random_date,
    updated_at: random_date
  }

  user = User.create(user_params)

  if user.persisted?
    puts "User created successfully: #{user.account}"
  else
    puts "Error creating user:"
    puts user.errors.full_messages
  end
end

# ユーザー作成
nicknames.each_with_index do |nickname, index|
  account = "oden#{index + 1}"
  create_user(account, nickname, tags)
end

# 投稿の作成メソッド
def create_posts_for_user_with_ordered_dates(user, count, status_options, tags)
  # ユーザーの最初の投稿日を設定
  initial_date = Time.now - (count - 1).days  # 最新の投稿が今日となるように設定
  
  count.times do |i|
    title = "投稿#{i + 1}"
    body = "サンプルの投稿#{i + 1}です。\n新鮮な野菜、チーズ、ハムなどお好みの具材を挟んだホットサンドは、軽食からランチまで幅広く楽しめる美味しい料理です。\nシンプルな食材で手軽に作れ、サクサクの食感ととろけるチーズの組み合わせが絶妙です。\nぜひ自宅で作ってみて、美味しいひとときを楽しんでみてください。"
    link = "https://www.youtube.com/watch?v=eYreBz3S7f8"
    status = status_options.sample
    impressions_count = rand(100..1000)
    tag_list = tags.sample(2)

    # 日付を順番に遅らせる
    post_date = initial_date + i.days

    post_params = {
      title: title,
      body: body,
      link: link,
      status: status,
      impressions_count: impressions_count,
      created_at: post_date,
      updated_at: post_date,
      user_id: user.id
    }
    puts "Creating post with params: #{post_params.inspect}"  # デバッグログを追加
    post = user.posts.create(post_params)
    post.tag_list.add(tag_list)  # タグを追加する
    post.save
    
    puts "Creating post with title: #{title}, user_account: #{user.account}, tag_list: #{tag_list}"
  end
end

# ユーザーごとに異なるステータス割り当て
User.where.not(account: 'guest').each do |user|
  # 既存の投稿を削除
  user.posts.delete_all

  # ランダムにステータスを選択
  statuses = [0] * 12 + [1] * 3 + [2] * 3
  create_posts_for_user_with_ordered_dates(user, 12, statuses, tags)  # 投稿を12個生成するように修正
end

# お気に入り投稿の作成
PostFavorite.delete_all
users = User.all
posts = Post.published  # ステータスが0（公開）の投稿のみ取得
users.each do |user|
  favorite_posts = posts.sample(rand(1..3))
  favorite_posts.each do |post|
    PostFavorite.create(
      user_id: user.id,
      post_id: post.id,
      created_at: Time.now,
      updated_at: Time.now
    )
  end
end

# コメントの作成
Comment.delete_all
CommentFavorite.delete_all

user_comments = [
  '素敵な投稿ですね。',
  '興味深い情報です。',
  '共感できる内容です。',
  '勉強になります。',
  '面白いです！'
]

users.each do |user|
  posts.each do |post|
    # 各ユーザーが1つの投稿に対して最大1つのコメントを生成
    num_comments = rand(0..1)
    next if num_comments.zero?  # コメントを生成しない場合はスキップ

    comment_text = user_comments.sample
    comment = Comment.create(
      user_id: user.id,
      post_id: post.id,
      comment: comment_text,
      created_at: Time.now,
      updated_at: Time.now
    )

    if rand(0..1) == 1
      CommentFavorite.create(
        user_id: user.id,
        comment_id: comment.id,
        created_at: Time.now,
        updated_at: Time.now
      )
    end
  end
end

# リレーションシップの作成
Relationship.delete_all
users.each do |user|
  following_users = users - [user]  # 自分自身以外のユーザーから選ぶ
  following_users.shuffle.take(rand(1..4)).each do |following_user|
    Relationship.create(
      follower_id: user.id,
      followed_id: following_user.id,
      created_at: Time.now,
      updated_at: Time.now
    )
  end
end
