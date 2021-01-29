Rails.application.routes.draw do
  get 'spa/index'
  root 'spa#index'

  namespace :api do
    resources :users, only: %i[index show create update] do
      member do
        patch :ban
        post 'session', to: 'users#login'
        delete 'session', to: 'users#logout'
      end
      resources :matches, only: [:index]
      resources :friendships, only: %i[index create destroy]
      resources :direct_chat_rooms, only: %i[index show create]
      resources :chat_bans, only: %i[index create destroy]
    end

    resources :tournaments, only: %i[index create] do
      member do
        patch :enroll, to: 'tournaments#enroll'
      end
    end

    resources :matches, only: %i[index create] do
      member do
        patch :report, to: 'matches#report'
        patch :join, to: 'matches#join'
      end
    end

    resources :wars, only: [] do
      resources :matches, only: %i[index create] do
        patch :join, to: 'matches#join'
      end
    end

    resources :guilds, only: %i[index create update show] do
      resources :guild_memberships, path: 'memberships', only: %i[index create update destroy]
      resources :wars, only: [:index]
      resources :war_requests, only: %i[index create destroy]
    end

    resources :group_chat_rooms, only: %i[index create update show destroy] do
      resources :chat_messages, only: %i[index create]
      resources :group_chat_memberships, path: 'memberships', only: %i[index create update destroy]
    end

    resources :direct_chat_rooms, only: [] do
      resources :chat_messages, only: %i[index create]
    end
  end
end
