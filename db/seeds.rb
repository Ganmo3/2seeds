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

# ユーザーアカウントとニックネームの配列
nicknames = ['がんも', 'だいこん', 'たまご', 'はんぺん', '牛すじ']

# ユーザーの作成
User.delete_all
users = nicknames.map.with_index do |nickname, index|
  account = "oden#{index + 1}"
  introduction = "よろしくお願いします、#{nickname}です。YouTubeチャンネルを登録するとYouTubeのチャンネルアイコンに変わります。"
  {
    account: account,
    nickname: nickname,
    email: "#{account}@2seeds.com",
    password: "123456",
    introduction: introduction,
    channel: "https://www.youtube.com/channel/UCUfZCxi6GBN4fam5kiwPUnA",
    status: 0,
    created_at: Time.now,
    updated_at: Time.now
  }
end

# ユーザー作成
users.each do |user_params|
  user = User.new(user_params)
  if user.save
    puts "User created successfully!"
  else
    puts "Error creating user:"
    puts user.errors.full_messages
  end
end

# タグの作成
tags = %w(旅行 料理 音楽 スポーツ アート)
tags.each { |tag_name| ActsAsTaggableOn::Tag.find_or_create_by(name: tag_name) }

# 投稿の作成メソッド
def create_user_posts(user, count, status_options, tags)
  count.times do |i|
    title = "投稿#{i + 1}"
    body = "サンプルの投稿#{i + 1}です。"
    link = "https://www.youtube.com/watch?v=eYreBz3S7f8"
    status = status_options.sample
    impressions_count = rand(100..1000)
    tag_list = tags.sample(2)

    post_params = {
      title: title,
      body: body,
      link: link,
      status: status,
      impressions_count: impressions_count,
      created_at: Time.now,
      updated_at: Time.now,
      user_id: user.id
    }
    puts "Creating post with params: #{post_params.inspect}"  # デバッグログを追加
    post = user.posts.create(post_params)
    post.tag_list.add(tag_list)  # タグを追加する
    post.save
    
    puts "Creating post with title: #{title}, user_account: #{user.account}, tag_list: #{tag_list}"
  end
end

# 通常ユーザーの投稿作成
User.where.not(account: 'guest').each do |user|
  # 既存の投稿を削除
  user.posts.delete_all

  create_user_posts(user, 3, [0], tags)  
end

# ゲストユーザーの投稿作成
#guest_user = User.find_by(account: 'guest')
#status_options = [0, 1, 2]  # ステータスを整数値で指定
#create_user_posts(guest_user, status_options.length, status_options, tags)


# お気に入り投稿の作成
PostFavorite.delete_all
users = User.all
posts = Post.all
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


