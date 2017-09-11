# frozen_string_literal: true

Rails.application.routes.draw do
  apipie
  # devise_for :users
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :boards, only: %i[index show create update destroy] do
        resources :tasks, only: %i[index show create update destroy], shallow: true
      end
    end
  end
end
