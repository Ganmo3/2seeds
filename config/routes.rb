Rails.application.routes.draw do
  # user用
  # URL /users/sign_in ...
  devise_for :users, controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions",
    passwords: "public/passwords"
  }

  # devise signout時のエラー解消
  devise_scope :user do
    get "/users/sign_out" => "devise/sessions#destroy"
    post "users/guest_sign_in", to: "public/sessions#guest_sign_in"
  end

  # devise signup時のエラー解消
  get "users" => redirect("/users/sign_up")

  scope module: :public do
    root to: "homes#top"
    get "/about" => "homes#about", as: "about"

    resources :posts do
      collection do
        get :dashboard
        get :analytics
        get :weekly_ranking
        get :trending
        post :preview
      end

      resource :post_favorites, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy] do
        resource :comment_favorites, only: [:create, :destroy]
      end
    end
    resources :comments, only: [:update]
    resources :tags, only: [:show]
    resources :reports, only: [:new, :create]

    # URLをaccount名に変更
    resources :users, param: :account, only: [:show, :edit, :update] do
      member do
        # いいねした一覧
        get :liked_posts

        # 退会機能
        get :withdraw_input
        patch :withdraw_process

        # フォロー機能
        post :follow, to: "relationships#create"
        delete :unfollow, to: "relationships#destroy"
        get :follower_list
        get :following_list

      end

      # 急上昇ユーザー一覧ページ
      get :rising_users, on: :collection
    end

    resources :notifications, only: [:index] do
      post :update_checked, on: :collection
    end

  end

  get "/search", to: "searches#search", as: :search
  get "/search/results", to: "searches#search_results", as: :search_results

  post "/chatbots", to: "chatbots#create"


  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, controllers: {
    sessions: "admin/sessions"
  }

  # devise signout時のエラー解消
  devise_scope :admin do
    get "/admin/sign_out" => "devise/sessions#destroy"
  end

  namespace :admin do
    root to: "homes#top"
    resources :posts, only: [:destroy]
    resources :comments, only: [:destroy]
    resources :users, only: [:index, :show, :update]
    resources :reports, only: [:show, :update]
  end

    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
