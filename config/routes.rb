Rails.application.routes.draw do
  get 't_tarifas/new'
  get 't_tarifas/edit'
  get 't_tarifas/index'
  get 't_tarifas/show'
  get 't_periodos/new'
  get 't_periodos/edit'
  get 't_periodos/index'
  get 't_periodos/show'
  root to: 'pages#index'
  devise_for :users
  resources :users
  resources :t_leyendas
  resources :t_periodos
  resources :t_tarifas
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #root to: 'users#index'
end
