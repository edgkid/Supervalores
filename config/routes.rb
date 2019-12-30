# == Route Map
#
#                                       Prefix Verb   URI Pattern                                                                              Controller#Action
#                              t_nota_creditos GET    /t_nota_creditos(.:format)                                                               t_nota_creditos#index
#                                              POST   /t_nota_creditos(.:format)                                                               t_nota_creditos#create
#                           new_t_nota_credito GET    /t_nota_creditos/new(.:format)                                                           t_nota_creditos#new
#                          edit_t_nota_credito GET    /t_nota_creditos/:id/edit(.:format)                                                      t_nota_creditos#edit
#                               t_nota_credito GET    /t_nota_creditos/:id(.:format)                                                           t_nota_creditos#show
#                                              PATCH  /t_nota_creditos/:id(.:format)                                                           t_nota_creditos#update
#                                              PUT    /t_nota_creditos/:id(.:format)                                                           t_nota_creditos#update
#                                              DELETE /t_nota_creditos/:id(.:format)                                                           t_nota_creditos#destroy
#                                         root GET    /                                                                                        dashboard#index
#                      dashboard_access_denied GET    /dashboard/access_denied(.:format)                                                       dashboard#access_denied
#                             new_user_session GET    /users/sign_in(.:format)                                                                 devise/sessions#new
#                                 user_session POST   /users/sign_in(.:format)                                                                 devise/sessions#create
#                         destroy_user_session DELETE /users/sign_out(.:format)                                                                devise/sessions#destroy
#                            new_user_password GET    /users/password/new(.:format)                                                            devise/passwords#new
#                           edit_user_password GET    /users/password/edit(.:format)                                                           devise/passwords#edit
#                                user_password PATCH  /users/password(.:format)                                                                devise/passwords#update
#                                              PUT    /users/password(.:format)                                                                devise/passwords#update
#                                              POST   /users/password(.:format)                                                                devise/passwords#create
#                     cancel_user_registration GET    /users/cancel(.:format)                                                                  devise/registrations#cancel
#                        new_user_registration GET    /users/sign_up(.:format)                                                                 devise/registrations#new
#                       edit_user_registration GET    /users/edit(.:format)                                                                    devise/registrations#edit
#                            user_registration PATCH  /users(.:format)                                                                         devise/registrations#update
#                                              PUT    /users(.:format)                                                                         devise/registrations#update
#                                              DELETE /users(.:format)                                                                         devise/registrations#destroy
#                                              POST   /users(.:format)                                                                         devise/registrations#create
#                                        users GET    /users(.:format)                                                                         admin/users#index
#                                              POST   /users(.:format)                                                                         admin/users#create
#                                     new_user GET    /users/new(.:format)                                                                     admin/users#new
#                                    edit_user GET    /users/:id/edit(.:format)                                                                admin/users#edit
#                                         user GET    /users/:id(.:format)                                                                     admin/users#show
#                                              PATCH  /users/:id(.:format)                                                                     admin/users#update
#                                              PUT    /users/:id(.:format)                                                                     admin/users#update
#                                              DELETE /users/:id(.:format)                                                                     admin/users#destroy
#                       get_total_t_caja_index GET    /t_caja/get_total(.:format)                                                              t_caja#get_total
#                                 t_caja_index GET    /t_caja(.:format)                                                                        t_caja#index
#                                   t_leyendas GET    /t_leyendas(.:format)                                                                    t_leyendas#index
#                                              POST   /t_leyendas(.:format)                                                                    t_leyendas#create
#                                new_t_leyenda GET    /t_leyendas/new(.:format)                                                                t_leyendas#new
#                               edit_t_leyenda GET    /t_leyendas/:id/edit(.:format)                                                           t_leyendas#edit
#                                    t_leyenda GET    /t_leyendas/:id(.:format)                                                                t_leyendas#show
#                                              PATCH  /t_leyendas/:id(.:format)                                                                t_leyendas#update
#                                              PUT    /t_leyendas/:id(.:format)                                                                t_leyendas#update
#                                              DELETE /t_leyendas/:id(.:format)                                                                t_leyendas#destroy
#                                   t_periodos GET    /periodos(.:format)                                                                      t_periodos#index
#                                              POST   /periodos(.:format)                                                                      t_periodos#create
#                                new_t_periodo GET    /periodos/new(.:format)                                                                  t_periodos#new
#                               edit_t_periodo GET    /periodos/:id/edit(.:format)                                                             t_periodos#edit
#                                    t_periodo GET    /periodos/:id(.:format)                                                                  t_periodos#show
#                                              PATCH  /periodos/:id(.:format)                                                                  t_periodos#update
#                                              PUT    /periodos/:id(.:format)                                                                  t_periodos#update
#                                              DELETE /periodos/:id(.:format)                                                                  t_periodos#destroy
#                                    t_tarifas GET    /tarifas(.:format)                                                                       t_tarifas#index
#                                              POST   /tarifas(.:format)                                                                       t_tarifas#create
#                                 new_t_tarifa GET    /tarifas/new(.:format)                                                                   t_tarifas#new
#                                edit_t_tarifa GET    /tarifas/:id/edit(.:format)                                                              t_tarifas#edit
#                                     t_tarifa GET    /tarifas/:id(.:format)                                                                   t_tarifas#show
#                                              PATCH  /tarifas/:id(.:format)                                                                   t_tarifas#update
#                                              PUT    /tarifas/:id(.:format)                                                                   t_tarifas#update
#                                              DELETE /tarifas/:id(.:format)                                                                   t_tarifas#destroy
#                       automaticas_t_facturas GET    /automaticas/t_facturas(.:format)                                                        automaticas/t_facturas#index
#                                              POST   /automaticas/t_facturas(.:format)                                                        automaticas/t_facturas#create
#                    new_automaticas_t_factura GET    /automaticas/t_facturas/new(.:format)                                                    automaticas/t_facturas#new
#                   edit_automaticas_t_factura GET    /automaticas/t_facturas/:id/edit(.:format)                                               automaticas/t_facturas#edit
#                        automaticas_t_factura GET    /automaticas/t_facturas/:id(.:format)                                                    automaticas/t_facturas#show
#                                              PATCH  /automaticas/t_facturas/:id(.:format)                                                    automaticas/t_facturas#update
#                                              PUT    /automaticas/t_facturas/:id(.:format)                                                    automaticas/t_facturas#update
#                                              DELETE /automaticas/t_facturas/:id(.:format)                                                    automaticas/t_facturas#destroy
#                            preview_t_factura GET    /t_facturas/:id/preview(.:format)                                                        t_facturas#preview
#                        generar_pdf_t_factura GET    /t_facturas/:id/generar_pdf(.:format)                                                    t_facturas#generar_pdf
#               generar_pdf_t_factura_t_recibo GET    /t_facturas/:t_factura_id/t_recibos/:id/generar_pdf(.:format)                            t_recibos#generar_pdf
#       generar_reporte_pdf_t_factura_t_recibo GET    /t_facturas/:t_factura_id/t_recibos/:id/generar_reporte_pdf(.:format)                    t_recibos#generar_reporte_pdf
#                          t_factura_t_recibos GET    /t_facturas/:t_factura_id/t_recibos(.:format)                                            t_recibos#index
#                                              POST   /t_facturas/:t_factura_id/t_recibos(.:format)                                            t_recibos#create
#                       new_t_factura_t_recibo GET    /t_facturas/:t_factura_id/t_recibos/new(.:format)                                        t_recibos#new
#                      edit_t_factura_t_recibo GET    /t_facturas/:t_factura_id/t_recibos/:id/edit(.:format)                                   t_recibos#edit
#                           t_factura_t_recibo GET    /t_facturas/:t_factura_id/t_recibos/:id(.:format)                                        t_recibos#show
#                                              PATCH  /t_facturas/:t_factura_id/t_recibos/:id(.:format)                                        t_recibos#update
#                                              PUT    /t_facturas/:t_factura_id/t_recibos/:id(.:format)                                        t_recibos#update
#                                              DELETE /t_facturas/:t_factura_id/t_recibos/:id(.:format)                                        t_recibos#destroy
#                           pagadas_t_facturas GET    /t_facturas/pagadas(.:format)                                                            t_facturas#pagadas
#                     total_pagadas_t_facturas GET    /t_facturas/total_pagadas(.:format)                                                      t_facturas#total_pagadas
#               informe_recaudacion_t_facturas GET    /t_facturas/informe_recaudacion(.:format)                                                t_facturas#informe_recaudacion
#                 recaudacion_total_t_facturas GET    /t_facturas/recaudacion_total(.:format)                                                  t_facturas#recaudacion_total
#          informe_ingresos_diarios_t_facturas GET    /t_facturas/informe_ingresos_diarios(.:format)                                           t_facturas#informe_ingresos_diarios
#      informe_ingresos_presupuesto_t_facturas GET    /t_facturas/informe_ingresos_presupuesto(.:format)                                       t_facturas#informe_ingresos_presupuesto
#          informe_cuentas_x_cobrar_t_facturas GET    /t_facturas/informe_cuentas_x_cobrar(.:format)                                           t_facturas#informe_cuentas_x_cobrar
#            total_cuentas_x_cobrar_t_facturas GET    /t_facturas/total_cuentas_x_cobrar(.:format)                                             t_facturas#total_cuentas_x_cobrar
#            informe_presupuestario_t_facturas GET    /t_facturas/informe_presupuestario(.:format)                                             t_facturas#informe_presupuestario
#      informe_por_tipos_de_ingreso_t_facturas GET    /t_facturas/informe_por_tipos_de_ingreso(.:format)                                       t_facturas#informe_por_tipos_de_ingreso
#                                   t_facturas GET    /t_facturas(.:format)                                                                    t_facturas#index
#                                              POST   /t_facturas(.:format)                                                                    t_facturas#create
#                                new_t_factura GET    /t_facturas/new(.:format)                                                                t_facturas#new
#                               edit_t_factura GET    /t_facturas/:id/edit(.:format)                                                           t_facturas#edit
#                                    t_factura GET    /t_facturas/:id(.:format)                                                                t_facturas#show
#                                              PATCH  /t_facturas/:id(.:format)                                                                t_facturas#update
#                                              PUT    /t_facturas/:id(.:format)                                                                t_facturas#update
#                                              DELETE /t_facturas/:id(.:format)                                                                t_facturas#destroy
#                       t_conf_fac_automaticas GET    /t_conf_fac_automaticas(.:format)                                                        t_conf_fac_automaticas#index
#                                              POST   /t_conf_fac_automaticas(.:format)                                                        t_conf_fac_automaticas#create
#                    new_t_conf_fac_automatica GET    /t_conf_fac_automaticas/new(.:format)                                                    t_conf_fac_automaticas#new
#                   edit_t_conf_fac_automatica GET    /t_conf_fac_automaticas/:id/edit(.:format)                                               t_conf_fac_automaticas#edit
#                        t_conf_fac_automatica GET    /t_conf_fac_automaticas/:id(.:format)                                                    t_conf_fac_automaticas#show
#                                              PATCH  /t_conf_fac_automaticas/:id(.:format)                                                    t_conf_fac_automaticas#update
#                                              PUT    /t_conf_fac_automaticas/:id(.:format)                                                    t_conf_fac_automaticas#update
#                                              DELETE /t_conf_fac_automaticas/:id(.:format)                                                    t_conf_fac_automaticas#destroy
#               comparativa_ingresos_t_recibos GET    /t_recibos/comparativa_ingresos(.:format)                                                t_recibos#comparativa_ingresos
# comparativa_ingresos_no_datatables_t_recibos GET    /t_recibos/comparativa_ingresos_no_datatables(.:format)                                  t_recibos#comparativa_ingresos_no_datatables
#                pago_recibido_total_t_recibos GET    /t_recibos/pago_recibido_total(.:format)                                                 t_recibos#pago_recibido_total
#                                    t_recibos GET    /t_recibos(.:format)                                                                     t_recibos#index
#              all_services_t_tarifa_servicios GET    /t_tarifa_servicios/all_services(.:format)                                               t_tarifa_servicios#all_services
#                  tramites_t_tarifa_servicios GET    /t_tarifa_servicios/tramites(.:format)                                                   t_tarifa_servicios#tramites
#                           t_tarifa_servicios GET    /t_tarifa_servicios(.:format)                                                            t_tarifa_servicios#index
#                                              POST   /t_tarifa_servicios(.:format)                                                            t_tarifa_servicios#create
#                        new_t_tarifa_servicio GET    /t_tarifa_servicios/new(.:format)                                                        t_tarifa_servicios#new
#                       edit_t_tarifa_servicio GET    /t_tarifa_servicios/:id/edit(.:format)                                                   t_tarifa_servicios#edit
#                            t_tarifa_servicio GET    /t_tarifa_servicios/:id(.:format)                                                        t_tarifa_servicios#show
#                                              PATCH  /t_tarifa_servicios/:id(.:format)                                                        t_tarifa_servicios#update
#                                              PUT    /t_tarifa_servicios/:id(.:format)                                                        t_tarifa_servicios#update
#                                              DELETE /t_tarifa_servicios/:id(.:format)                                                        t_tarifa_servicios#destroy
#               t_recargos_find_by_descripcion GET    /t_recargos/find_by_descripcion(.:format)                                                t_recargos#find_by_descripcion
#                                   t_emisions GET    /emisiones(.:format)                                                                     t_emisions#index
#                                              POST   /emisiones(.:format)                                                                     t_emisions#create
#                                new_t_emision GET    /emisiones/new(.:format)                                                                 t_emisions#new
#                               edit_t_emision GET    /emisiones/:id/edit(.:format)                                                            t_emisions#edit
#                                    t_emision GET    /emisiones/:id(.:format)                                                                 t_emisions#show
#                                              PATCH  /emisiones/:id(.:format)                                                                 t_emisions#update
#                                              PUT    /emisiones/:id(.:format)                                                                 t_emisions#update
#                                              DELETE /emisiones/:id(.:format)                                                                 t_emisions#destroy
#                              t_tipo_emisions GET    /tipo_de_emisiones(.:format)                                                             t_tipo_emisions#index
#                                              POST   /tipo_de_emisiones(.:format)                                                             t_tipo_emisions#create
#                           new_t_tipo_emision GET    /tipo_de_emisiones/new(.:format)                                                         t_tipo_emisions#new
#                          edit_t_tipo_emision GET    /tipo_de_emisiones/:id/edit(.:format)                                                    t_tipo_emisions#edit
#                               t_tipo_emision GET    /tipo_de_emisiones/:id(.:format)                                                         t_tipo_emisions#show
#                                              PATCH  /tipo_de_emisiones/:id(.:format)                                                         t_tipo_emisions#update
#                                              PUT    /tipo_de_emisiones/:id(.:format)                                                         t_tipo_emisions#update
#                                              DELETE /tipo_de_emisiones/:id(.:format)                                                         t_tipo_emisions#destroy
#                                   t_recargos GET    /recargos(.:format)                                                                      t_recargos#index
#                                              POST   /recargos(.:format)                                                                      t_recargos#create
#                                new_t_recargo GET    /recargos/new(.:format)                                                                  t_recargos#new
#                               edit_t_recargo GET    /recargos/:id/edit(.:format)                                                             t_recargos#edit
#                                    t_recargo GET    /recargos/:id(.:format)                                                                  t_recargos#show
#                                              PATCH  /recargos/:id(.:format)                                                                  t_recargos#update
#                                              PUT    /recargos/:id(.:format)                                                                  t_recargos#update
#                                              DELETE /recargos/:id(.:format)                                                                  t_recargos#destroy
#                                t_resolucions GET    /resoluciones(.:format)                                                                  t_resolucions#index
#                                              POST   /resoluciones(.:format)                                                                  t_resolucions#create
#                             new_t_resolucion GET    /resoluciones/new(.:format)                                                              t_resolucions#new
#                            edit_t_resolucion GET    /resoluciones/:id/edit(.:format)                                                         t_resolucions#edit
#                                 t_resolucion GET    /resoluciones/:id(.:format)                                                              t_resolucions#show
#                                              PATCH  /resoluciones/:id(.:format)                                                              t_resolucions#update
#                                              PUT    /resoluciones/:id(.:format)                                                              t_resolucions#update
#                                              DELETE /resoluciones/:id(.:format)                                                              t_resolucions#destroy
#                              get_type_client GET    /get_type_client(.:format)                                                               t_resolucions#get_type_client
#                            get_cliente_saldo GET    /get_cliente_saldo(.:format)                                                             t_resolucions#cliente_saldo
#                      informe_t_tipo_clientes GET    /tipos_de_clientes/informe(.:format)                                                     t_tipo_clientes#informe
#                 clients_index_t_tipo_cliente GET    /tipos_de_clientes/:id/clients_index(.:format)                                           t_tipo_clientes#clients_index
#                              t_tipo_clientes GET    /tipos_de_clientes(.:format)                                                             t_tipo_clientes#index
#                                              POST   /tipos_de_clientes(.:format)                                                             t_tipo_clientes#create
#                           new_t_tipo_cliente GET    /tipos_de_clientes/new(.:format)                                                         t_tipo_clientes#new
#                          edit_t_tipo_cliente GET    /tipos_de_clientes/:id/edit(.:format)                                                    t_tipo_clientes#edit
#                               t_tipo_cliente GET    /tipos_de_clientes/:id(.:format)                                                         t_tipo_clientes#show
#                                              PATCH  /tipos_de_clientes/:id(.:format)                                                         t_tipo_clientes#update
#                                              PUT    /tipos_de_clientes/:id(.:format)                                                         t_tipo_clientes#update
#                                              DELETE /tipos_de_clientes/:id(.:format)                                                         t_tipo_clientes#destroy
#                              t_tipo_personas GET    /tipos_de_personas(.:format)                                                             t_tipo_personas#index
#                                              POST   /tipos_de_personas(.:format)                                                             t_tipo_personas#create
#                           new_t_tipo_persona GET    /tipos_de_personas/new(.:format)                                                         t_tipo_personas#new
#                          edit_t_tipo_persona GET    /tipos_de_personas/:id/edit(.:format)                                                    t_tipo_personas#edit
#                               t_tipo_persona GET    /tipos_de_personas/:id(.:format)                                                         t_tipo_personas#show
#                                              PATCH  /tipos_de_personas/:id(.:format)                                                         t_tipo_personas#update
#                                              PUT    /tipos_de_personas/:id(.:format)                                                         t_tipo_personas#update
#                                              DELETE /tipos_de_personas/:id(.:format)                                                         t_tipo_personas#destroy
#                        t_cliente_generar_pdf GET    /clientes/:t_cliente_id/generar_pdf(.:format)                                            t_clientes#generar_pdf
#                          tramites_t_clientes GET    /clientes/tramites(.:format)                                                             t_clientes#tramites
#                             total_t_clientes GET    /clientes/total(.:format)                                                                t_clientes#total
#                                   t_clientes GET    /clientes(.:format)                                                                      t_clientes#index
#                                              POST   /clientes(.:format)                                                                      t_clientes#create
#                                new_t_cliente GET    /clientes/new(.:format)                                                                  t_clientes#new
#                               edit_t_cliente GET    /clientes/:id/edit(.:format)                                                             t_clientes#edit
#                                    t_cliente GET    /clientes/:id(.:format)                                                                  t_clientes#show
#                                              PATCH  /clientes/:id(.:format)                                                                  t_clientes#update
#                                              PUT    /clientes/:id(.:format)                                                                  t_clientes#update
#                                              DELETE /clientes/:id(.:format)                                                                  t_clientes#destroy
#                       t_clientes_all_clients GET    /t_clientes/all_clients(.:format)                                                        t_clientes#all_clients
#                    t_clientes_find_by_codigo GET    /t_clientes/find_by_codigo(.:format)                                                     t_clientes#find_by_codigo
#                t_clientes_find_by_resolucion GET    /t_clientes/find_by_resolucion(.:format)                                                 t_clientes#find_by_resolucion
#                    t_clientes_find_by_cedula GET    /t_clientes/find_by_cedula(.:format)                                                     t_clientes#find_by_cedula
#                              t_clientes_find GET    /t_clientes/find(.:format)                                                               t_clientes#find
#                                              GET    /clientes/:id/resolucion/:resolucion(.:format)                                           t_clientes#mostrar_resolucion
#                            estados_de_cuenta GET    /estados_de_cuenta(.:format)                                                             t_clientes#estado_cuenta
#                           calculo_de_totales GET    /calculo_de_totales(.:format)                                                            t_clientes#estado_cuenta_calculo_de_totales
#                                              POST   /clientes/:id/nueva_resolucion(.:format)                                                 t_clientes#nueva_resolucion
#                                  t_estatuses GET    /estatus(.:format)                                                                       t_estatuses#index
#                                              POST   /estatus(.:format)                                                                       t_estatuses#create
#                                new_t_estatus GET    /estatus/new(.:format)                                                                   t_estatuses#new
#                               edit_t_estatus GET    /estatus/:id/edit(.:format)                                                              t_estatuses#edit
#                                    t_estatus GET    /estatus/:id(.:format)                                                                   t_estatuses#show
#                                              PATCH  /estatus/:id(.:format)                                                                   t_estatuses#update
#                                              PUT    /estatus/:id(.:format)                                                                   t_estatuses#update
#                                              DELETE /estatus/:id(.:format)                                                                   t_estatuses#destroy
#                                   t_personas GET    /personas(.:format)                                                                      t_personas#index
#                                              POST   /personas(.:format)                                                                      t_personas#create
#                                new_t_persona GET    /personas/new(.:format)                                                                  t_personas#new
#                               edit_t_persona GET    /personas/:id/edit(.:format)                                                             t_personas#edit
#                                    t_persona GET    /personas/:id(.:format)                                                                  t_personas#show
#                                              PATCH  /personas/:id(.:format)                                                                  t_personas#update
#                                              PUT    /personas/:id(.:format)                                                                  t_personas#update
#                                              DELETE /personas/:id(.:format)                                                                  t_personas#destroy
#                                   t_empresas GET    /empresas(.:format)                                                                      t_empresas#index
#                                              POST   /empresas(.:format)                                                                      t_empresas#create
#                                new_t_empresa GET    /empresas/new(.:format)                                                                  t_empresas#new
#                               edit_t_empresa GET    /empresas/:id/edit(.:format)                                                             t_empresas#edit
#                                    t_empresa GET    /empresas/:id(.:format)                                                                  t_empresas#show
#                                              PATCH  /empresas/:id(.:format)                                                                  t_empresas#update
#                                              PUT    /empresas/:id(.:format)                                                                  t_empresas#update
#                                              DELETE /empresas/:id(.:format)                                                                  t_empresas#destroy
#                        t_empresa_tipo_valors GET    /tipo_valor_para_empresas(.:format)                                                      t_empresa_tipo_valors#index
#                                              POST   /tipo_valor_para_empresas(.:format)                                                      t_empresa_tipo_valors#create
#                     new_t_empresa_tipo_valor GET    /tipo_valor_para_empresas/new(.:format)                                                  t_empresa_tipo_valors#new
#                    edit_t_empresa_tipo_valor GET    /tipo_valor_para_empresas/:id/edit(.:format)                                             t_empresa_tipo_valors#edit
#                         t_empresa_tipo_valor GET    /tipo_valor_para_empresas/:id(.:format)                                                  t_empresa_tipo_valors#show
#                                              PATCH  /tipo_valor_para_empresas/:id(.:format)                                                  t_empresa_tipo_valors#update
#                                              PUT    /tipo_valor_para_empresas/:id(.:format)                                                  t_empresa_tipo_valors#update
#                                              DELETE /tipo_valor_para_empresas/:id(.:format)                                                  t_empresa_tipo_valors#destroy
#                  t_empresa_sector_economicos GET    /sector_economico_para_empresas(.:format)                                                t_empresa_sector_economicos#index
#                                              POST   /sector_economico_para_empresas(.:format)                                                t_empresa_sector_economicos#create
#               new_t_empresa_sector_economico GET    /sector_economico_para_empresas/new(.:format)                                            t_empresa_sector_economicos#new
#              edit_t_empresa_sector_economico GET    /sector_economico_para_empresas/:id/edit(.:format)                                       t_empresa_sector_economicos#edit
#                   t_empresa_sector_economico GET    /sector_economico_para_empresas/:id(.:format)                                            t_empresa_sector_economicos#show
#                                              PATCH  /sector_economico_para_empresas/:id(.:format)                                            t_empresa_sector_economicos#update
#                                              PUT    /sector_economico_para_empresas/:id(.:format)                                            t_empresa_sector_economicos#update
#                                              DELETE /sector_economico_para_empresas/:id(.:format)                                            t_empresa_sector_economicos#destroy
#                         t_tipo_cliente_tipos GET    /tipo_para_tipo_cliente(.:format)                                                        t_tipo_cliente_tipos#index
#                                              POST   /tipo_para_tipo_cliente(.:format)                                                        t_tipo_cliente_tipos#create
#                      new_t_tipo_cliente_tipo GET    /tipo_para_tipo_cliente/new(.:format)                                                    t_tipo_cliente_tipos#new
#                     edit_t_tipo_cliente_tipo GET    /tipo_para_tipo_cliente/:id/edit(.:format)                                               t_tipo_cliente_tipos#edit
#                          t_tipo_cliente_tipo GET    /tipo_para_tipo_cliente/:id(.:format)                                                    t_tipo_cliente_tipos#show
#                                              PATCH  /tipo_para_tipo_cliente/:id(.:format)                                                    t_tipo_cliente_tipos#update
#                                              PUT    /tipo_para_tipo_cliente/:id(.:format)                                                    t_tipo_cliente_tipos#update
#                                              DELETE /tipo_para_tipo_cliente/:id(.:format)                                                    t_tipo_cliente_tipos#destroy
#                               t_metodo_pagos GET    /t_metodo_pagos(.:format)                                                                t_metodo_pagos#index
#                                              POST   /t_metodo_pagos(.:format)                                                                t_metodo_pagos#create
#                            new_t_metodo_pago GET    /t_metodo_pagos/new(.:format)                                                            t_metodo_pagos#new
#                           edit_t_metodo_pago GET    /t_metodo_pagos/:id/edit(.:format)                                                       t_metodo_pagos#edit
#                                t_metodo_pago GET    /t_metodo_pagos/:id(.:format)                                                            t_metodo_pagos#show
#                                              PATCH  /t_metodo_pagos/:id(.:format)                                                            t_metodo_pagos#update
#                                              PUT    /t_metodo_pagos/:id(.:format)                                                            t_metodo_pagos#update
#                                              DELETE /t_metodo_pagos/:id(.:format)                                                            t_metodo_pagos#destroy
#                                modules_t_rol GET    /t_rols/:id/modules(.:format)                                                            t_rols#modules
#                            permissions_t_rol GET    /t_rols/:id/permissions(.:format)                                                        t_rols#permissions
#                                       t_rols GET    /t_rols(.:format)                                                                        t_rols#index
#                                              POST   /t_rols(.:format)                                                                        t_rols#create
#                                    new_t_rol GET    /t_rols/new(.:format)                                                                    t_rols#new
#                                   edit_t_rol GET    /t_rols/:id/edit(.:format)                                                               t_rols#edit
#                                        t_rol GET    /t_rols/:id(.:format)                                                                    t_rols#show
#                                              PATCH  /t_rols/:id(.:format)                                                                    t_rols#update
#                                              PUT    /t_rols/:id(.:format)                                                                    t_rols#update
#                                              DELETE /t_rols/:id(.:format)                                                                    t_rols#destroy
#                                    t_modulos GET    /t_modulos(.:format)                                                                     t_modulos#index
#                                     redirect GET    /redirect(.:format)                                                                      t_tipo_clientes#redirect
#                           rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
#                    rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#                           rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
#                    update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#                         rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create

Rails.application.routes.draw do
  resources :t_nota_creditos
  root to: 'dashboard#index'
  get 'dashboard/access_denied' => 'dashboard#access_denied'

  devise_for :users
  # devise_for :users, controllers: { sessions: 'users/sessions' }

  namespace :admin do
    resources :users
  end
  # scope module: 'admin' do
  #   resources :users
  # end
  resources :t_caja, only: :index do
    get 'get_total', on: :collection
  end
  # get 'caja_get_total' => 't_caja#get_total'
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
      get 'generar_reporte_pdf', on: :member
    end
    collection do
      get 'pagadas'
      get 'total_pagadas'
      get 'informe_recaudacion'
      get 'recaudacion_total'
      get 'informe_ingresos_diarios'
      get 'informe_ingresos_presupuesto'
      get 'informe_cuentas_x_cobrar'
      get 'total_cuentas_x_cobrar'
      get 'informe_presupuestario'
      get 'informe_por_tipos_de_ingreso'
      get 'estado_de_cuenta'
      get 'filtrar_estado_de_cuenta'
      get 'mostrar_datos_del_cliente'
    end
  end
  resources :t_conf_fac_automaticas
  resources :t_recibos, only: :index do
    collection do
      get 'comparativa_ingresos'
      get 'comparativa_ingresos_no_datatables'
      get 'pago_recibido_total'
    end
  end
  resources :t_tarifa_servicios do
    collection do
      get 'all_services'
      get 'tramites'
    end
  end
  namespace :t_recargos do
    get 'find_by_descripcion', as: :find_by_descripcion
  end
  resources :t_emisions, path: "emisiones"
  resources :t_tipo_emisions, path: "tipo_de_emisiones"
  resources :t_recargos, path: "recargos"
  resources :t_resolucions, path: "resoluciones"
  get 'get_type_client' => 't_resolucions#get_type_client'
  get 'get_cliente_saldo' => 't_resolucions#cliente_saldo'
  
  resources :t_tipo_clientes, path: "tipos_de_clientes" do
    collection do
      get 'informe'
      get 'total_meses'
      get 'total_facturas'
    end
    get 'clients_index', on: :member
  end
  resources :t_tipo_personas, path: "tipos_de_personas"
  resources :t_clientes, path: "clientes" do
    get 'generar_pdf'
    collection do
      get 'tramites'
      get 'total'
    end
  end
  namespace :t_clientes do
    get 'all_clients'
    get 'find_by_codigo', as: :find_by_codigo
    get 'find_by_resolucion', as: :find_by_resolucion
    get 'find_by_cedula', as: :find_by_cedula
    get 'find_by_razon_social', as: :find_by_razon_social
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
  resources :t_configuracion_recargo_ts

  get "redirect" => "t_tipo_clientes#redirect"
end
