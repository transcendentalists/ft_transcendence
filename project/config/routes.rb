Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  root 'spa#ft_auth'
  delete 'api/session', to: 'spa#destroy'
  get 'auth/42/callback', to: 'spa#index'
  post 'auth/42/two_factor', to: 'spa#mail_auth'
  get 'api/admin/db', to: 'api/admin#index'

  namespace :api do
    resources :users, only: %i[index show create update destroy] do
      member do
        post 'session', to: 'users#login'
        delete 'session', to: 'users#logout'
      end
      resources :matches, only: [:index]
      resources :friendships, only: %i[index create destroy]
      resources :direct_chat_rooms, only: %i[get show]
      resources :guild_invitations, only: %i[index create destroy]
      resources :chat_bans, only: %i[index show create destroy]
    end

    resources :tournaments, only: %i[index create] do
      resources :tournament_memberships, path: 'memberships', only: [:create]
    end

    resources :matches, only: %i[index create]

    resources :wars, only: [] do
      resources :matches, only: %i[index create]
    end

    resources :guilds, only: %i[index create show] do
      resources :guild_memberships, path: 'memberships', only: %i[index create update destroy]
      resources :wars, only: [:index]
      resources :war_requests, only: %i[index create update]
    end

    resources :guild_memberships, only: %i[destroy update]

    resources :group_chat_rooms, only: %i[index create update show destroy] do
      resources :chat_messages, only: %i[index]
      resources :group_chat_memberships, path: 'memberships', only: %i[update destroy]
    end
    resources :group_chat_memberships, only: %i[update destroy]

    resources :direct_chat_rooms do
      resources :chat_messages, only: %i[index]
    end
  end
end
