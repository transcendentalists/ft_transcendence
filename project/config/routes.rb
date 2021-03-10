Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  root 'spa#index'
  # root 'spa#ft_auth'
  delete 'api/session', to: 'spa#destroy'
  get 'auth/42/callback', to: 'spa#index'
  post 'auth/mail/callback', to: 'spa#mail_auth'
  get 'api/admin/db', to: 'api/admin#index'

  namespace :api do
    resources :users, only: %i[index show create update destroy] do
      member do
        patch :ban
        post 'session', to: 'users#login'
        delete 'session', to: 'users#logout'
      end
      resources :matches, only: [:index]
      resources :friendships, only: %i[index create destroy]
      resources :direct_chat_rooms, only: %i[index show create]
      resources :guild_invitations, only: %i[index show create destroy]
      resources :chat_bans, only: %i[index show create destroy]
    end

    resources :tournaments, only: %i[index create] do
      resources :tournament_memberships, path: 'memberships', only: [:create]
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
      resources :war_requests, only: %i[index create update]
    end

    resources :guild_memberships, only: %i[destroy update]

    resources :group_chat_rooms, only: %i[index create update show destroy] do
      resources :chat_messages, only: %i[index create]
      resources :group_chat_memberships, path: 'memberships', only: %i[update destroy]
    end
    resources :group_chat_memberships, only: %i[update destroy]

    resources :direct_chat_rooms, only: [] do
      resources :chat_messages, only: %i[index create]
    end
  end
end
