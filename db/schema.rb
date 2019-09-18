# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_09_18_023333) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "crono_jobs", force: :cascade do |t|
    t.string "job_id", null: false
    t.text "log"
    t.datetime "last_performed_at"
    t.boolean "healthy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_crono_jobs_on_job_id", unique: true
  end

  create_table "t_cajas", force: :cascade do |t|
    t.float "pago_recibido", null: false
    t.float "monto_factura", null: false
    t.float "vuelto", null: false
    t.string "tipo", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "t_recibo_id", null: false
    t.bigint "user_id", null: false
    t.index ["t_recibo_id"], name: "index_t_cajas_on_t_recibo_id"
    t.index ["user_id"], name: "index_t_cajas_on_user_id"
  end

  create_table "t_catalogo_cuenta", force: :cascade do |t|
    t.string "codigo", null: false
    t.string "descripcion", null: false
    t.integer "estatus", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "t_tipo_cuenta_id", null: false
    t.index ["t_tipo_cuenta_id"], name: "index_t_catalogo_cuenta_on_t_tipo_cuenta_id"
  end

  create_table "t_catalogo_cuenta_subs", force: :cascade do |t|
    t.string "codigo", null: false
    t.string "descripcion", null: false
    t.integer "estatus", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "t_catalogo_cuentum_id"
    t.bigint "t_presupuesto_id", null: false
    t.index ["t_catalogo_cuentum_id"], name: "index_t_catalogo_cuenta_subs_on_t_catalogo_cuentum_id"
    t.index ["t_presupuesto_id"], name: "index_t_catalogo_cuenta_subs_on_t_presupuesto_id"
  end

  create_table "t_cliente_tarifas", force: :cascade do |t|
    t.float "monto", null: false
    t.date "fecha", null: false
    t.integer "estatus", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "t_tarifa_id", null: false
    t.bigint "t_resolucion_id", null: false
    t.bigint "t_periodo_id", null: false
    t.index ["t_periodo_id"], name: "index_t_cliente_tarifas_on_t_periodo_id"
    t.index ["t_resolucion_id"], name: "index_t_cliente_tarifas_on_t_resolucion_id"
    t.index ["t_tarifa_id"], name: "index_t_cliente_tarifas_on_t_tarifa_id"
  end

  create_table "t_clientes", force: :cascade do |t|
    t.string "codigo", null: false
    t.integer "t_estatus_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "prospecto_at"
    t.bigint "persona_id", null: false
    t.string "persona_type", null: false
    t.index ["codigo"], name: "index_t_clientes_on_codigo", unique: true
    t.index ["persona_type", "persona_id"], name: "index_persona_as_cliente"
    t.index ["t_estatus_id"], name: "index_t_clientes_on_t_estatus_id"
  end

  create_table "t_conf_fac_automaticas", force: :cascade do |t|
    t.string "nombre_ciclo_facturacion"
    t.date "fecha_inicio"
    t.bigint "t_tipo_cliente_id"
    t.bigint "t_periodo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "estatus"
    t.bigint "user_id"
    t.index ["t_periodo_id"], name: "index_t_conf_fac_automaticas_on_t_periodo_id"
    t.index ["t_tipo_cliente_id"], name: "index_t_conf_fac_automaticas_on_t_tipo_cliente_id"
    t.index ["user_id"], name: "index_t_conf_fac_automaticas_on_user_id"
  end

  create_table "t_contactos", force: :cascade do |t|
    t.string "nombre"
    t.string "apellido"
    t.string "telefono"
    t.string "direccion"
    t.string "email"
    t.string "empresa"
    t.bigint "t_resolucion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["t_resolucion_id"], name: "index_t_contactos_on_t_resolucion_id"
  end

  create_table "t_cuenta_financieras", force: :cascade do |t|
    t.string "codigo_presupuesto"
    t.string "codigo_financiero"
    t.string "descripcion_financiera"
    t.string "descripcion_presupuestaria"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "t_tarifa_servicio_group_id", null: false
    t.bigint "t_presupuesto_id", null: false
    t.index ["t_presupuesto_id"], name: "index_t_cuenta_financieras_on_t_presupuesto_id"
    t.index ["t_tarifa_servicio_group_id"], name: "index_t_cuenta_financieras_on_t_tarifa_servicio_group_id"
  end

  create_table "t_cuenta_venta", force: :cascade do |t|
    t.string "descripcion"
    t.integer "estatus"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "t_email_masivos", force: :cascade do |t|
    t.string "email", null: false
    t.string "detalle_envio", null: false
    t.datetime "fecha_ejecucion", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "t_cliente_id", null: false
    t.bigint "t_factura_id", null: false
    t.bigint "user_id", null: false
    t.index ["t_cliente_id"], name: "index_t_email_masivos_on_t_cliente_id"
    t.index ["t_factura_id"], name: "index_t_email_masivos_on_t_factura_id"
    t.index ["user_id"], name: "index_t_email_masivos_on_user_id"
  end

  create_table "t_emisions", force: :cascade do |t|
    t.date "fecha_emision", null: false
    t.float "valor_circulacion", null: false
    t.float "tasa", null: false
    t.float "monto_pagar", null: false
    t.integer "estatus", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "t_periodo_id", null: false
    t.bigint "t_tipo_emision_id", null: false
    t.bigint "user_id", null: false
    t.index ["t_periodo_id"], name: "index_t_emisions_on_t_periodo_id"
    t.index ["t_tipo_emision_id"], name: "index_t_emisions_on_t_tipo_emision_id"
    t.index ["user_id"], name: "index_t_emisions_on_user_id"
  end

  create_table "t_empresa_sector_economicos", force: :cascade do |t|
    t.string "descripcion"
    t.integer "estatus"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "t_empresa_tipo_valors", force: :cascade do |t|
    t.string "descripcion"
    t.integer "estatus"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "t_empresas", force: :cascade do |t|
    t.string "rif", null: false
    t.string "razon_social", null: false
    t.string "direccion_empresa"
    t.string "fax"
    t.string "web"
    t.string "telefono"
    t.string "email"
    t.bigint "t_empresa_tipo_valor_id", null: false
    t.bigint "t_empresa_sector_economico_id", null: false
    t.index ["rif"], name: "index_t_empresas_on_rif", unique: true
  end

  create_table "t_estado_cuenta", force: :cascade do |t|
    t.float "debito", null: false
    t.float "credito", null: false
    t.float "recargo", null: false
    t.float "saldo", null: false
    t.datetime "fecha_generacion", null: false
    t.datetime "fech_vencimiento", null: false
    t.string "tipo", null: false
    t.string "estado", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "t_cliente_id", null: false
    t.bigint "t_factura_id"
    t.bigint "t_recibo_id"
    t.bigint "user_id", null: false
    t.index ["t_cliente_id"], name: "index_t_estado_cuenta_on_t_cliente_id"
    t.index ["t_factura_id"], name: "index_t_estado_cuenta_on_t_factura_id"
    t.index ["t_recibo_id"], name: "index_t_estado_cuenta_on_t_recibo_id"
    t.index ["user_id"], name: "index_t_estado_cuenta_on_user_id"
  end

  create_table "t_estado_cuenta_conts", force: :cascade do |t|
    t.string "detalle", null: false
    t.float "debito", null: false
    t.float "credito", null: false
    t.float "saldo", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "t_estado_cuentum_id", null: false
    t.bigint "t_factura_detalle_id", null: false
    t.bigint "t_tarifa_servicio_id", null: false
    t.bigint "t_catalogo_cuenta_sub_id", null: false
    t.index ["t_catalogo_cuenta_sub_id"], name: "index_t_estado_cuenta_conts_on_t_catalogo_cuenta_sub_id"
    t.index ["t_estado_cuentum_id"], name: "index_t_estado_cuenta_conts_on_t_estado_cuentum_id"
    t.index ["t_factura_detalle_id"], name: "index_t_estado_cuenta_conts_on_t_factura_detalle_id"
    t.index ["t_tarifa_servicio_id"], name: "index_t_estado_cuenta_conts_on_t_tarifa_servicio_id"
  end

  create_table "t_estatuses", force: :cascade do |t|
    t.integer "estatus", null: false
    t.integer "para", default: 0, null: false
    t.string "descripcion", null: false
    t.string "color", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "t_factura_detalles", force: :cascade do |t|
    t.integer "cantidad", null: false
    t.string "cuenta_desc", null: false
    t.float "precio_unitario", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "t_factura_id", null: false
    t.bigint "t_tarifa_servicio_id", null: false
    t.index ["t_factura_id"], name: "index_t_factura_detalles_on_t_factura_id"
    t.index ["t_tarifa_servicio_id"], name: "index_t_factura_detalles_on_t_tarifa_servicio_id"
  end

  create_table "t_factura_recargos", force: :cascade do |t|
    t.bigint "t_conf_fac_automatica_id"
    t.bigint "t_recargo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["t_conf_fac_automatica_id"], name: "index_t_factura_recargos_on_t_conf_fac_automatica_id"
    t.index ["t_recargo_id"], name: "index_t_factura_recargos_on_t_recargo_id"
  end

  create_table "t_factura_servicios", force: :cascade do |t|
    t.bigint "t_conf_fac_automatica_id"
    t.bigint "t_tarifa_servicio_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["t_conf_fac_automatica_id"], name: "index_t_factura_servicios_on_t_conf_fac_automatica_id"
    t.index ["t_tarifa_servicio_id"], name: "index_t_factura_servicios_on_t_tarifa_servicio_id"
  end

  create_table "t_factura_tarifas", force: :cascade do |t|
    t.bigint "t_conf_fac_automatica_id"
    t.bigint "t_tarifa_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["t_conf_fac_automatica_id"], name: "index_t_factura_tarifas_on_t_conf_fac_automatica_id"
    t.index ["t_tarifa_id"], name: "index_t_factura_tarifas_on_t_tarifa_id"
  end

  create_table "t_facturas", force: :cascade do |t|
    t.date "fecha_notificacion", null: false
    t.date "fecha_vencimiento", null: false
    t.float "recargo", null: false
    t.float "recargo_desc", null: false
    t.float "itbms", null: false
    t.integer "cantidad_total"
    t.float "importe_total", null: false
    t.float "total_factura", null: false
    t.float "pendiente_fact", null: false
    t.float "pendiente_ts", null: false
    t.string "tipo", null: false
    t.string "justificacion"
    t.datetime "fecha_erroneo"
    t.date "next_fecha_recargo", null: false
    t.float "monto_emision", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "t_resolucion_id", null: false
    t.bigint "t_periodo_id", null: false
    t.bigint "t_estatus_id", null: false
    t.bigint "t_leyenda_id"
    t.bigint "user_id", null: false
    t.boolean "automatica", default: false
    t.index ["t_estatus_id"], name: "index_t_facturas_on_t_estatus_id"
    t.index ["t_leyenda_id"], name: "index_t_facturas_on_t_leyenda_id"
    t.index ["t_periodo_id"], name: "index_t_facturas_on_t_periodo_id"
    t.index ["t_resolucion_id"], name: "index_t_facturas_on_t_resolucion_id"
    t.index ["user_id"], name: "index_t_facturas_on_user_id"
  end

  create_table "t_leyendas", force: :cascade do |t|
    t.integer "anio"
    t.string "descripcion"
    t.integer "estatus"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "t_metodo_pagos", force: :cascade do |t|
    t.string "forma_pago", null: false
    t.string "descripcion", null: false
    t.decimal "minimo"
    t.decimal "maximo"
    t.integer "estatus", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "t_modulo_rols", force: :cascade do |t|
    t.bigint "t_rol_id"
    t.bigint "t_modulo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["t_modulo_id"], name: "index_t_modulo_rols_on_t_modulo_id"
    t.index ["t_rol_id"], name: "index_t_modulo_rols_on_t_rol_id"
  end

  create_table "t_modulos", force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "alias"
  end

  create_table "t_nota_creditos", force: :cascade do |t|
    t.float "monto", null: false
    t.string "detalle", null: false
    t.datetime "fecha_sistema", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "t_cliente_id", null: false
    t.bigint "t_recibo_id", null: false
    t.bigint "t_factura_id", null: false
    t.bigint "user_id", null: false
    t.index ["t_cliente_id"], name: "index_t_nota_creditos_on_t_cliente_id"
    t.index ["t_factura_id"], name: "index_t_nota_creditos_on_t_factura_id"
    t.index ["t_recibo_id"], name: "index_t_nota_creditos_on_t_recibo_id"
    t.index ["user_id"], name: "index_t_nota_creditos_on_user_id"
  end

  create_table "t_otros", force: :cascade do |t|
    t.string "identificacion"
    t.string "razon_social"
    t.string "telefono"
    t.string "email"
    t.bigint "t_tipo_persona_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["t_tipo_persona_id"], name: "index_t_otros_on_t_tipo_persona_id"
  end

  create_table "t_periodos", force: :cascade do |t|
    t.string "descripcion", null: false
    t.integer "rango_dias", null: false
    t.integer "dia_tope", null: false
    t.integer "mes_tope", null: false
    t.integer "estatus", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "t_permiso_modulo_rols", force: :cascade do |t|
    t.bigint "t_permiso_id"
    t.bigint "t_modulo_rol_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["t_modulo_rol_id"], name: "index_t_permiso_modulo_rols_on_t_modulo_rol_id"
    t.index ["t_permiso_id"], name: "index_t_permiso_modulo_rols_on_t_permiso_id"
  end

  create_table "t_permisos", force: :cascade do |t|
    t.string "nombre"
    t.integer "estatus"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "t_personas", force: :cascade do |t|
    t.string "cedula", null: false
    t.string "nombre", null: false
    t.string "apellido", null: false
    t.bigint "num_licencia", null: false
    t.bigint "t_empresa_id"
    t.string "cargo"
    t.string "telefono"
    t.string "email"
    t.string "direccion"
    t.index ["cedula"], name: "index_t_personas_on_cedula", unique: true
    t.index ["t_empresa_id"], name: "index_t_personas_on_t_empresa_id"
  end

  create_table "t_presupuestos", force: :cascade do |t|
    t.string "codigo"
    t.string "descripcion"
    t.integer "estatus"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "t_recargo_x_clientes", force: :cascade do |t|
    t.string "monto", null: false
    t.date "fecha", null: false
    t.integer "estatus", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "t_recargo_id", null: false
    t.bigint "t_resolucion_id", null: false
    t.index ["t_recargo_id"], name: "index_t_recargo_x_clientes_on_t_recargo_id"
    t.index ["t_resolucion_id"], name: "index_t_recargo_x_clientes_on_t_resolucion_id"
  end

  create_table "t_recargos", force: :cascade do |t|
    t.string "descripcion", null: false
    t.float "tasa", null: false
    t.integer "estatus", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "t_factura_id"
    t.bigint "t_periodo_id"
    t.index ["t_factura_id"], name: "index_t_recargos_on_t_factura_id"
  end

  create_table "t_recibos", force: :cascade do |t|
    t.date "fecha_pago", null: false
    t.string "num_cheque"
    t.float "pago_recibido", null: false
    t.float "monto_acreditado", null: false
    t.integer "cuenta_deposito"
    t.float "pago_pendiente", null: false
    t.integer "estatus", null: false
    t.string "justificacion"
    t.datetime "fecha_erroneo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "t_factura_id", null: false
    t.bigint "t_cliente_id", null: false
    t.bigint "t_periodo_id", null: false
    t.bigint "t_metodo_pago_id", null: false
    t.bigint "user_id", null: false
    t.index ["t_cliente_id"], name: "index_t_recibos_on_t_cliente_id"
    t.index ["t_factura_id"], name: "index_t_recibos_on_t_factura_id"
    t.index ["t_metodo_pago_id"], name: "index_t_recibos_on_t_metodo_pago_id"
    t.index ["t_periodo_id"], name: "index_t_recibos_on_t_periodo_id"
    t.index ["user_id"], name: "index_t_recibos_on_user_id"
  end

  create_table "t_resolucions", force: :cascade do |t|
    t.string "descripcion", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "t_cliente_id", null: false
    t.bigint "t_estatus_id", null: false
    t.integer "resolucion_anio"
    t.string "resolucion_codigo"
    t.bigint "t_tipo_cliente_id"
    t.index ["resolucion_anio", "resolucion_codigo"], name: "index_t_resolucions_on_resolucion_anio_and_resolucion_codigo", unique: true
    t.index ["t_cliente_id"], name: "index_t_resolucions_on_t_cliente_id"
    t.index ["t_estatus_id"], name: "index_t_resolucions_on_t_estatus_id"
    t.index ["t_tipo_cliente_id"], name: "index_t_resolucions_on_t_tipo_cliente_id"
  end

  create_table "t_rol_usuarios", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "t_rol_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["t_rol_id"], name: "index_t_rol_usuarios_on_t_rol_id"
    t.index ["user_id"], name: "index_t_rol_usuarios_on_user_id"
  end

  create_table "t_rols", force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.integer "estatus"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "t_tarifa_servicio_groups", force: :cascade do |t|
    t.string "nombre", null: false
    t.integer "estatus", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "t_presupuesto_id", null: false
    t.index ["t_presupuesto_id"], name: "index_t_tarifa_servicio_groups_on_t_presupuesto_id"
  end

  create_table "t_tarifa_servicios", force: :cascade do |t|
    t.string "codigo", null: false
    t.string "descripcion", null: false
    t.string "nombre", null: false
    t.string "clase", null: false
    t.float "precio", null: false
    t.integer "estatus", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "t_tarifas", force: :cascade do |t|
    t.string "nombre"
    t.string "descripcion"
    t.string "rango_monto"
    t.float "recargo"
    t.string "estatus"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "monto"
  end

  create_table "t_tarifas_periodos", id: false, force: :cascade do |t|
    t.bigint "t_tarifa_id", null: false
    t.bigint "t_periodo_id", null: false
    t.index ["t_periodo_id"], name: "index_t_tarifas_periodos_on_t_periodo_id"
    t.index ["t_tarifa_id"], name: "index_t_tarifas_periodos_on_t_tarifa_id"
  end

  create_table "t_tipo_cliente_tipos", force: :cascade do |t|
    t.string "descripcion"
    t.integer "estatus"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "t_tipo_clientes", force: :cascade do |t|
    t.string "codigo", null: false
    t.string "descripcion", null: false
    t.integer "estatus", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "t_tarifa_id", null: false
    t.bigint "t_tipo_cliente_tipo_id", null: false
    t.bigint "t_periodo_id"
    t.index ["codigo"], name: "index_t_tipo_clientes_on_codigo", unique: true
    t.index ["t_tarifa_id"], name: "index_t_tipo_clientes_on_t_tarifa_id"
  end

  create_table "t_tipo_cuenta", force: :cascade do |t|
    t.string "descripcion", null: false
    t.integer "estatus", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "t_tipo_emisions", force: :cascade do |t|
    t.string "descripcion"
    t.integer "estatus"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "t_tipo_personas", force: :cascade do |t|
    t.string "descripcion"
    t.integer "estatus"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "nombre"
    t.string "apellido"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "picture"
    t.string "role"
    t.integer "estatus"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "t_cajas", "t_recibos"
  add_foreign_key "t_cajas", "users"
  add_foreign_key "t_catalogo_cuenta", "t_tipo_cuenta", column: "t_tipo_cuenta_id"
  add_foreign_key "t_catalogo_cuenta_subs", "t_catalogo_cuenta"
  add_foreign_key "t_catalogo_cuenta_subs", "t_presupuestos"
  add_foreign_key "t_cliente_tarifas", "t_periodos"
  add_foreign_key "t_cliente_tarifas", "t_resolucions"
  add_foreign_key "t_cliente_tarifas", "t_tarifas"
  add_foreign_key "t_clientes", "t_estatuses"
  add_foreign_key "t_conf_fac_automaticas", "t_periodos"
  add_foreign_key "t_conf_fac_automaticas", "t_tipo_clientes"
  add_foreign_key "t_conf_fac_automaticas", "users"
  add_foreign_key "t_contactos", "t_resolucions"
  add_foreign_key "t_cuenta_financieras", "t_presupuestos"
  add_foreign_key "t_cuenta_financieras", "t_tarifa_servicio_groups"
  add_foreign_key "t_email_masivos", "t_clientes"
  add_foreign_key "t_email_masivos", "t_facturas"
  add_foreign_key "t_email_masivos", "users"
  add_foreign_key "t_emisions", "t_periodos"
  add_foreign_key "t_emisions", "t_tipo_emisions"
  add_foreign_key "t_emisions", "users"
  add_foreign_key "t_empresas", "t_empresa_sector_economicos"
  add_foreign_key "t_empresas", "t_empresa_tipo_valors"
  add_foreign_key "t_estado_cuenta", "t_clientes"
  add_foreign_key "t_estado_cuenta", "t_facturas"
  add_foreign_key "t_estado_cuenta", "t_recibos"
  add_foreign_key "t_estado_cuenta", "users"
  add_foreign_key "t_estado_cuenta_conts", "t_catalogo_cuenta_subs"
  add_foreign_key "t_estado_cuenta_conts", "t_estado_cuenta"
  add_foreign_key "t_estado_cuenta_conts", "t_factura_detalles"
  add_foreign_key "t_estado_cuenta_conts", "t_tarifa_servicios"
  add_foreign_key "t_factura_detalles", "t_facturas"
  add_foreign_key "t_factura_detalles", "t_tarifa_servicios"
  add_foreign_key "t_factura_recargos", "t_conf_fac_automaticas"
  add_foreign_key "t_factura_recargos", "t_recargos"
  add_foreign_key "t_factura_servicios", "t_conf_fac_automaticas"
  add_foreign_key "t_factura_servicios", "t_tarifa_servicios"
  add_foreign_key "t_factura_tarifas", "t_conf_fac_automaticas"
  add_foreign_key "t_factura_tarifas", "t_tarifas"
  add_foreign_key "t_facturas", "t_estatuses"
  add_foreign_key "t_facturas", "t_leyendas"
  add_foreign_key "t_facturas", "t_periodos"
  add_foreign_key "t_facturas", "t_resolucions"
  add_foreign_key "t_facturas", "users"
  add_foreign_key "t_modulo_rols", "t_modulos"
  add_foreign_key "t_modulo_rols", "t_rols"
  add_foreign_key "t_nota_creditos", "t_clientes"
  add_foreign_key "t_nota_creditos", "t_facturas"
  add_foreign_key "t_nota_creditos", "t_recibos"
  add_foreign_key "t_nota_creditos", "users"
  add_foreign_key "t_otros", "t_tipo_personas"
  add_foreign_key "t_permiso_modulo_rols", "t_modulo_rols"
  add_foreign_key "t_permiso_modulo_rols", "t_permisos"
  add_foreign_key "t_personas", "t_empresas"
  add_foreign_key "t_recargo_x_clientes", "t_recargos"
  add_foreign_key "t_recargo_x_clientes", "t_resolucions"
  add_foreign_key "t_recargos", "t_facturas"
  add_foreign_key "t_recibos", "t_clientes"
  add_foreign_key "t_recibos", "t_facturas"
  add_foreign_key "t_recibos", "t_metodo_pagos"
  add_foreign_key "t_recibos", "t_periodos"
  add_foreign_key "t_recibos", "users"
  add_foreign_key "t_resolucions", "t_clientes"
  add_foreign_key "t_resolucions", "t_estatuses"
  add_foreign_key "t_resolucions", "t_tipo_clientes"
  add_foreign_key "t_rol_usuarios", "t_rols"
  add_foreign_key "t_rol_usuarios", "users"
  add_foreign_key "t_tarifa_servicio_groups", "t_presupuestos"
  add_foreign_key "t_tarifas_periodos", "t_periodos"
  add_foreign_key "t_tarifas_periodos", "t_tarifas"
  add_foreign_key "t_tipo_clientes", "t_tarifas"
  add_foreign_key "t_tipo_clientes", "t_tipo_cliente_tipos"
end
