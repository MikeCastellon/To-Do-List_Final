Rails.application.routes.draw do
  root 'tasks#index'
  devise_for :users

  resources :tasks, only: [:index, :create, :destroy, :update] do
    resources :sub_tasks, only: [:index, :create, :update, :destroy], shallow: true
  end

  resource :calendar, only: [:show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
