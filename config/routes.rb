Rails.application.routes.draw do

  root to: 'dashboard#index'
  get 'dashboard/access_denied' => 'dashboard#access_denied'

  devise_for :users

  namespace :admin do
    resources :users
  end
  resources :t_leyendas
  resources :t_periodos, path: "periodos"
  resources :t_tarifas, path: "tarifas"
  resources :t_facturas do
    get 'preview', on: :member
  end
  # get 't_facturas/previsualizacion' => 't_facturas#preview', as: :previsualizar_factura
  resources :t_tarifa_servicios
  namespace :t_recargos do
    get 'find_by_descripcion', as: :find_by_descripcion
  end
  resources :t_emisions, path: "emisiones"
  resources :t_tipo_emisions, path: "tipo_de_emisiones"
  resources :t_recargos, path: "recargos"
  resources :t_resolucions, path: "resoluciones"
  resources :t_tipo_clientes, path: "tipos_de_clientes"
  resources :t_tipo_personas, path: "tipos_de_personas"
  resources :t_clientes, path: "clientes"
  namespace :t_clientes do
    get 'find_by_codigo', as: :find_by_codigo
    get 'find_by_resolucion', as: :find_by_resolucion
    get 'find_by_cedula', as: :find_by_cedula
    get 'find', as: :find
  end
  get 'clientes/:id/resolucion/:resolucion' => 't_clientes#mostrar_resolucion'
  post 'clientes/:id/nueva_resolucion' => 't_clientes#nueva_resolucion'
  resources :t_estatuses, path: "estatus"
  resources :t_personas, path: "personas"
  resources :t_empresas, path: "empresas"
  resources :t_empresa_tipo_valors, path: "tipo_valor_para_empresas"
  resources :t_empresa_sector_economicos, path: "sector_economico_para_empresas"
  resources :t_tipo_cliente_tipos, path: "tipo_para_tipo_cliente"

  get "redirect" => "t_tipo_clientes#redirect"

  #routes roles
  get 'rols/index' => 't_rols#index'
  get 'rols/show/:id' => 't_rols#show'

  get 'rols/edit/:id' => 't_rols#edit'
  post 'rols/update/:id' =>'t_rols#update'

  get 'rols/new' => 't_rols#new'
  post 'rols/create' => "t_rols#create"

  get 'rols/destroy/:id' => 't_rols#destroy'

  #metodo de pago
  get 't_metodo_pagos/index' => 't_metodo_pagos#index'

  get 't_metodo_pagos/new' => 't_metodo_pagos#new'
  post 't_metodo_pagos/create' => 't_metodo_pagos#create'

  get 't_metodo_pagos/edit/:id' => 't_metodo_pagos#edit'
  post 't_metodo_pagos/update/:id' => 't_metodo_pagos#update'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #root to: 'users#index'
end
