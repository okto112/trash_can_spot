Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  devise_for :admin, skip: [:registrations, :password], controllers: {
    sessions: "admin/sessions"
  }

  root to: "public/homes#top"

  devise_scope :user do
    post "users/guest_sign_in", to: "public/sessions#guest_sign_in"
  end

  namespace :public do
    get '/users/my_page', to: 'users#show'
    get '/users/information/edit', to: 'users#edit'
    patch '/users/information', to: 'users#update'
    get '/users/unsubscribe', to: 'users#unsubscribe'
    patch '/users/withdraw', to: 'users#withdraw'
    get '/main', to: 'homes#main'
    resources :spots, only: [:new, :index, :show, :create, :edit, :update, :destroy]
    resources :favorites, only: [:index, :show, :create, :destroy]
    resources :comments, only: [:new,:index, :show, :create, :edit, :update, :destroy]
  end

  namespace :admin do
      root to: "homes#top"
      resources :users, only: [:index, :show, :edit, :update]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
