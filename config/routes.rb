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

  scope module: :public do
    root 'homes#top'

    resources :users, only: [:show, :edit, :update, :index] do
      resources :announcements, only: [:new,:create, :edit, :update, :destroy]
      member do
        get :favorites
      end
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
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
