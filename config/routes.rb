Rails.application.routes.draw do
  # user用
  # URL /users/sign_in ...
  devise_for :users, controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions",
    passwords: "public/passwords"
  }
  
  # devise signup時のエラー解消
  get "users" => redirect("/users/sign_up")
  
  scope module: :public do
    root to: "homes#top"
    get "/about" => "homes#about", as: "about"
    
    resources :posts do
      collection do
        get :dashboard
        post :preview
        patch :autosave
      end
      
      member do
        post "share_on_twitter"
      end
      
      resource :post_favorites, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy] do
        resource :comment_favorites, only: [:create, :destroy]
      end
    end
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
    end
    
    resources :notifications, only: [:index] do
      post :update_checked, on: :collection
    end
    
  end

  get "/search", to: "searches#search"
  post "/chatbots", to: "chatbots#create"


  
  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, controllers: {
    sessions: "admin/sessions"
  }
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
