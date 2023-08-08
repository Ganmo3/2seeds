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
        post :create_draft
      end
      
      member do
        get :edit_draft
        patch :update_draft
        delete :destroy_draft
      end
      
      resource :favorite, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
      resources :post_tags, only: [:create, :destroy]
    end
    resources :tags, only: [:create, :show]
    
    resources :users, param: :account, only: [:show, :edit, :update] do
      member do
        get :liked_posts
        get :withdraw_input
        patch :withdraw_process
      end
    end
    
  end



  
  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, controllers: {
    sessions: "admin/sessions"
  }
  
  
  
  
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
