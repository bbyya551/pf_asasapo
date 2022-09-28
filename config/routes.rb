Rails.application.routes.draw do

  namespace :admin do
    get 'reports/index'
    get 'reports/show'
    get 'reports/update'
  end
  namespace :public do
    get 'reports/new'
    get 'reports/create'
  end
  namespace :public do
    get 'announcements/edit'
  end
  devise_for :admin,skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    get 'top' => 'homes#top', as: 'top'
    resources :reports, only: [:index, :show, :update]
    resources :users, only: [:show, :edit, :update, :index]
    resources :posts, only: [:show, :index, :destroy] do
      resources :post_comments, only: [:destroy, :index]
    end
    resources :groups, only: [:index, :destroy, :show] do
      resources :reviews, only: [:index, :destroy]
    end
  end

  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  scope module: :public do
    root 'homes#top'

    resources :users, only: [:show, :edit, :update, :index] do
      resources :announcements, only: [:new,:create, :edit, :update, :destroy]
      member do
        get :favorites
      end
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
      resources :reports, only: [:new, :create]
      get "private_posts" => "users#private_posts"
    end

    resources :posts do
      resources :post_comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
    end
    resources :groups do
      resource :group_users, only: [:create, :destroy]
      get "new/mail" => "groups#new_mail"
      get "send/mail" => "groups#send_mail"
      resources :reviews, only: [:index, :create]
    end

    get "tags" => "groups#tags"

    resources :notifications, only: [:index, :update]

    get '/search', to: 'searches#search'

    resources :chats, only: [:show, :create]
    resources :rooms, only: [:index]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
