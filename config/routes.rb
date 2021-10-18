Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'on_call_periods#index'

  resource :on_call_period, only: [:create]
  resources :on_call_units, only: [:edit, :update]
end
