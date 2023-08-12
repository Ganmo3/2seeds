Rails.application.routes.draw do
  # user用
  # URL /users/sign_in ...
  devise_for :users, controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions",
    passwords: "public/passwords"
  }
  
  scope module: :public do
    root to: "homes#top"
    
    resources :posts do
      collection do
        get :drafts
      end
      
      member do
        post 'share_on_twitter'
      end
      
      resource :post_favorite, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy] do
        resource :comment_favorite, only: [:create, :destroy]
      end
      resources :post_tags, only: [:create, :destroy]
    end
    resources :tags, only: [:create, :show]
    resources :reports, only: [:create]
    
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
      end
    end
  end

  post "/chatbots", to: "chatbots#create"


  
  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, controllers: {
    sessions: "admin/sessions"
  }
  
  
  
  
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
