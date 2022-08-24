Rails.application.routes.draw do

  namespace :public do
    get 'announcements/edit'
  end
  devise_for :admin,skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    get 'top' => 'homes#top', as: 'top'
    resources :users, only: [:show, :edit, :update, :index]
    resources :posts, only: [:show, :index, :destroy] do
      resources :post_comments, only: [:destroy, :index]
    end
    resources :groups, only: [:index, :destroy, :show]
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
    end

    resources :posts do
      resources :post_comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
    end
    resources :groups, except: [:destroy] do
      resource :group_users, only: [:create, :destroy]
      get "new/mail" => "groups#new_mail"
      get "send/mail" => "groups#send_mail"
    end

    resources :notifications, only: [:index]

    get '/search', to: 'searches#search'

    resources :chats, only: [:show, :create]
    # resources :rooms, only: [:create, :show]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
