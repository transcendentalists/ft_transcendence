Rails.application.routes.draw do
  root 'posts#index'

  get 'posts/index'
  get 'posts/new'
  post 'posts/create'
  get 'posts/show/:id' => "posts#show"
  get 'posts/edit/:id' => "posts#edit"
  post 'posts/update/:id' => "posts#update"
  get 'posts/destroy/:id' => "posts#destroy"
  get 'home/form'
  get 'home/next'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
