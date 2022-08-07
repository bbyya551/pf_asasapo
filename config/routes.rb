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
    end

    resources :posts do
      resources :post_comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
    end
    resources :groups, except: [:destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
