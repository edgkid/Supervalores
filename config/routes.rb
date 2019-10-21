Rails.application.routes.draw do
  root to: 'dashboard#index'
  get 'dashboard/access_denied' => 'dashboard#access_denied'

  devise_for :users

  # namespace :admin do
  #   resources :users
  # end
  scope module: 'admin' do
    resources :users
  end
  resources :t_caja, only: :index
  resources :t_leyendas
  resources :t_periodos, path: "periodos"
  resources :t_tarifas, path: "tarifas"
  namespace :automaticas do
    resources :t_facturas
  end
  resources :t_facturas do
    member do
      get 'preview'
      get 'generar_pdf'
    end
    resources :t_recibos do
      get 'generar_pdf', on: :member
    end
    get 'pagadas', on: :collection
  end
  resources :t_conf_fac_automaticas
  resources :t_recibos, only: :index
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
  resources :t_clientes, path: "clientes" do
    get 'tramites', on: :collection
  end
  namespace :t_clientes do
    get 'find_by_codigo', as: :find_by_codigo
    get 'find_by_resolucion', as: :find_by_resolucion
    get 'find_by_cedula', as: :find_by_cedula
    get 'find', as: :find
  end
  get 'clientes/:id/resolucion/:resolucion' => 't_clientes#mostrar_resolucion'
  get 'estados_de_cuenta' => 't_clientes#estado_cuenta'
  get 'calculo_de_totales' => 't_clientes#estado_cuenta_calculo_de_totales'
  post 'clientes/:id/nueva_resolucion' => 't_clientes#nueva_resolucion'
  resources :t_estatuses, path: "estatus"
  resources :t_personas, path: "personas"
  resources :t_empresas, path: "empresas"
  resources :t_empresa_tipo_valors, path: "tipo_valor_para_empresas"
  resources :t_empresa_sector_economicos, path: "sector_economico_para_empresas"
  resources :t_tipo_cliente_tipos, path: "tipo_para_tipo_cliente"
  resources :t_metodo_pagos
  resources :t_rols do
    member do
      get 'modules'
      get 'permissions'
    end
  end
  resources :t_modulos, only: :index

  get "redirect" => "t_tipo_clientes#redirect"
end
