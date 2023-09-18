# 2Seeds
​
## サイト概要
### サイトテーマ
"2Seeds"は動画クリエイター（Youtuber）が自身の動画コンテンツのリンクと共に記事を公開できるブログサイトです。


### テーマを選んだ理由
以下の点からこのテーマを選びました。
1. 自身の背景

私自身が動画コンテンツを作成しており、コンテンツをブログとしても展開したいと考えました。
動画を投稿し始めた当初は視聴回数が全く伸びず、視聴者獲得に苦戦した経験がありました。
ブログを通じて動画の内容を伝え、興味を持ってもらえることで、
動画の再生回数やチャンネルの登録者数の増加を期待したいです。

2. 外部背景

[サイバーエージェントの調査結果](https://www.cyberagent.co.jp/news/detail/id=28533)によると、動画広告の市場規模は
2022年の5,601億円の市場規模から2026年には1兆2,451億円と、約2.2倍の成長が予想されています。
動画プラットフォームが今後も成長が期待できる市場であることから、
新規参入する動画クリエイターが増えると予想されます。

また、ブログの利用率は、[2022年の10代～50代へLINEリサーチ](https://lineresearch-platform.blog.jp/archives/39590287.html)によると、
全体の52%の人が普段からブログを見る傾向があります。
また近年ではマイクロブログの人気も高まっていることから、今後も一定の需要が続くと予想されます。

3. 問題点

動画投稿プラットフォームでは、特に駆け出しのクリエイターが視聴者の獲得が難しい課題があります。
Youtube等では、多くの動画がアップロードされているため、新しいコンテンツが埋もれてしまい、
視聴者を集めることが難しいです。
登録者数1000人を超えることが難しく、挫折してしまうクリエイターがとても多いです。

4. 解決策

ブログでも動画の内容を発信し、動画を見る前に内容を知ってもらえる環境を作りたいと考えました。
ブログは文章でコンテンツを公開する手段であり、動画よりも手軽に閲覧できるため、
より多くの人にアクセスしてもらえる可能性があります。
また、普段動画コンテンツは見ないけれども、ブログなら見ているというユーザーもいると考えています。
そのようなユーザーに興味を持ってもらうことができるかもしれません。

5. 期待される効果

動画コンテンツのテキスト化により、SEO対策になり、コンテンツが見つけられる可能性が高まると思います。
また、ブログを通じて動画の内容を伝え、興味を持ってもらうことで、動画の再生回数やチャンネルの登録者数
の増加が期待できます。

### 競合と差別化
1. 動画プラットフォームとの差別化

動画プラットフォームでは、多くの動画がアップロードされており、新しいコンテンツが埋もれやすいという課題がありますが、
"2Seeds"ではブログを通じて動画コンテンツを発信することで、アクセスしてもらえる可能性が高まります。
動画よりも手軽に閲覧できるテキスト形式のコンテンツは、
特に忙しいユーザーや情報収集に手間をかけたくないユーザーにとって魅力的です。


2. 他のブログプラットフォームとの差別化

"2Seeds"は動画クリエイターのみが投稿できる専用サイトであり、
初心者でも簡単に記事を投稿できる使いやすいインターフェースを提供します。
また、ユーザーも普段は見つけられない、興味深い動画により多く出会える可能性があります。


3. Twitterとの差別化

Twitterは文字制限があるため、詳細な情報や内容を伝えるのが難しいという制約があります。
"2Seeds"では文章を用いてより詳細にコンテンツを表現できるため、
読者はより深く理解しやすい情報を得ることができます。
また、"2Seeds"はブログ形式のため、長期的なコンテンツの保存や整理がしやすく、
過去の記事も容易にアクセスできる利点があります。


### ターゲットユーザ
1. 駆け出しの動画クリエイター（Youtuber）
2. 普段ブログを活用する読者
3. コンテンツ好きな一般ユーザー

​### 主な利用シーン
- 駆け出し動画クリエイターのブログ発信
- 視聴者のコンテンツ探し

## 設計書
- [実装機能リスト](https://docs.google.com/spreadsheets/d/1IKEIIgF9gjkuLv1vAXWJtswVwj657ZDvpVJUSlZzbV0/edit?usp=sharing)
- [ER図](https://viewer.diagrams.net/?tags=%7B%7D&highlight=0000ff&edit=_blank&layers=1&nav=1&title=2seeds.drawio#Uhttps%3A%2F%2Fraw.githubusercontent.com%2FGanmo3%2Fdrawio%2Fmain%2F2seeds.drawio)
- [テーブル定義書](https://docs.google.com/spreadsheets/d/1lAWPEyV9N0iK3HR92h8KX-l-o8PR1NATl8amYnyoq-Y/edit?usp=sharing)
- [アプリケーション詳細設計書](https://docs.google.com/spreadsheets/d/18j_40XPl1tqDtz9oDYATt7b2NeXC_fysV1027hO6ow4/edit#gid=549108681)
- [インフラ設計書](https://docs.google.com/spreadsheets/d/1AsAg6Z8v0BkMsnvSUh5lSJtNkMwutrQB/edit#gid=1237138394)
​
## 開発環境
- OS：Linux(CentOS)
- 言語：HTML,CSS,JavaScript,Ruby,SQL
- フレームワーク：Ruby on Rails
- JSライブラリ：jQuery
- IDE：Cloud9
- API：[Google-API-Client](https://github.com/googleapis/google-api-ruby-client), [OpenAi API](https://openai.com/)
- 分析：Google analytics4