Rails.application.routes.draw do

  root to: 'dashboard#index'

  devise_for :users

  resources :users
  resources :t_leyendas
  resources :t_periodos
  resources :t_tarifas

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
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #root to: 'users#index'
end
