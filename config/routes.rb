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
  resources :t_recargos

  resources :t_resolucions, :path => "resoluciones"
  resources :t_tipo_clientes, :path => "tipos_de_clientes"
  resources :t_tipo_personas, :path => "tipos_de_personas"
  resources :t_clientes, :path => "clientes"
  get 't_clientes/buscar', as: :buscar_t_cliente
  resources :t_estatuses, :path => "estatus"
  resources :t_personas, :path => "personas"
  resources :t_empresas, :path => "empresas"

  get "redirect" => "t_tipo_clientes#redirect"

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
