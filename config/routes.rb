Rails.application.routes.draw do
  root to: 'dashboard#index'

  devise_for :users

  namespace :admin do
    resources :users
  end
  resources :t_leyendas
  resources :t_periodos
  resources :t_tarifas
  resources :t_facturas
  resources :t_tarifa_servicios

  #routes tarifas
  get 't_tarifas/new'
  get 't_tarifas/edit'
  get 't_tarifas/index'
  get 't_tarifas/show'

  #routes periodos
  get 't_periodos/new'
  get 't_periodos/edit'
  get 't_periodos/index'
  get 't_periodos/show'

  #routes roles
  get 'rols/index' => 't_rols#index'
  get 'rols/show/:id' => 't_rols#show'

  get 'rols/edit/:id' => 't_rols#edit'
  post 'rols/update/:id' =>'t_rols#update'

  get 'rols/new' => 't_rols#new'
  post 'rols/create' => "t_rols#create"

  get 'rols/destroy/:id' => 't_rols#destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #root to: 'users#index'
end
