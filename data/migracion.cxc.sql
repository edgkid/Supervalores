/* Verificar si dblink esta disponible. */
SELECT pg_namespace.nspname, pg_proc.proname FROM pg_proc, pg_namespace WHERE pg_proc.pronamespace=pg_namespace.oid AND pg_proc.proname LIKE '%dblink%';
/* Verificar conexion. */
SELECT dblink_connect('cxc_server');

CREATE OR REPLACE VIEW cxc_login_attempts AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_usuario", "time" FROM "public"."login_attempts"') as dt( "idt_usuario" int4, "time" varchar(30));
CREATE OR REPLACE VIEW cxc_t_caja AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_caja", "idt_recibos", "pago_recibido", "monto_factura", "vuelto", "idt_usuario", "fecha", "tipo" FROM "public"."t_caja"') as dt( "idt_caja" int4, "idt_recibos" int4, "pago_recibido" numeric(16,2), "monto_factura" numeric(16,2), "vuelto" numeric(10), "idt_usuario" int4, "fecha" timestamp(6), "tipo" varchar(15));
CREATE OR REPLACE VIEW cxc_t_catalogo_cuentas AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_catalogo_cuentas", "idt_tipo_cuentas", "codigo", "descripcion", "estatus" FROM "public"."t_catalogo_cuentas"') as dt( "idt_catalogo_cuentas" int4, "idt_tipo_cuentas" int4, "codigo" varchar(15), "descripcion" varchar(35), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_catalogo_cuentas_old AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_catalogo_cuentas", "idt_tipo_cuentas", "codigo", "descripcion", "estatus" FROM "public"."t_catalogo_cuentas_old"') as dt( "idt_catalogo_cuentas" int4, "idt_tipo_cuentas" int4, "codigo" varchar(15), "descripcion" varchar(35), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_catalogo_cuentas_sub AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_catalogo_cuentas_sub", "idt_catalogo", "idt_presupuesto", "codigo", "descripcion", "estatus" FROM "public"."t_catalogo_cuentas_sub"') as dt( "idt_catalogo_cuentas_sub" int4, "idt_catalogo" int4, "idt_presupuesto" int4, "codigo" varchar(15), "descripcion" varchar(55), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_catalogo_cuentas_sub_old AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_catalogo_cuentas_sub", "idt_catalogo", "idt_presupuesto", "codigo", "descripcion", "estatus" FROM "public"."t_catalogo_cuentas_sub_old"') as dt( "idt_catalogo_cuentas_sub" int4, "idt_catalogo" int4, "idt_presupuesto" int4, "codigo" varchar(15), "descripcion" varchar(55), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_categoria AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_categoria", "descripcion", "formulario", "estatus" FROM "public"."t_categoria"') as dt( "idt_categoria" int4, "descripcion" varchar(50), "formulario" varchar(25), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_cliente_x_tarifa AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_cliente_x_tarifa", "idt_cliente", "idt_periodo", "idt_tarifa", "monto", "fecha", "fecha_registro", "hora_registro", "estatus" FROM "public"."t_cliente_x_tarifa"') as dt( "idt_cliente_x_tarifa" int4, "idt_cliente" int4, "idt_periodo" int4, "idt_tarifa" int4, "monto" numeric(16,2),"fecha" date, "fecha_registro" date, "hora_registro" time(6), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_clientes AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_clientes", "idt_tipo_cliente", "idt_tipo_emision", "cuenta_venta", "idt_cliente_padre", "idt_catalogo_cuentas", "codigo", "prospecto", "prospecto_date_in", "prospecto_date_out", "resolucion", "nombre", "apellido", "cedula", "empresa", "cargo", "direccion_empresa", "telefono", "fax", "email", "web", "num_licencia", "fecha_resolucion", "fecha_notificacion", "fecha_vencimiento", "fecha_vencimiento_fact", "monto_emision1", "idt_usuario", "fecha_registro", "hora_registro", "estatus" FROM "public"."t_clientes"') as dt( "idt_clientes" int4, "idt_tipo_cliente" int4, "idt_tipo_emision" int4, "cuenta_venta" int4, "idt_cliente_padre" int4, "idt_catalogo_cuentas" int4, "codigo" varchar(45),"prospecto" int4,"prospecto_date_in" date, "prospecto_date_out" date, "resolucion" varchar(100), "nombre" varchar(200), "apellido" varchar(50), "cedula" varchar(25), "empresa" varchar(60), "cargo" varchar(30), "direccion_empresa" varchar(75), "telefono" varchar(15), "fax" varchar(15), "email" varchar(200), "web" varchar(65), "num_licencia" int4,"fecha_resolucion" date,"fecha_notificacion" date, "fecha_vencimiento" date, "fecha_vencimiento_fact" date, "monto_emision1" numeric(16,2), "idt_usuario" int4, "fecha_registro" date, "hora_registro" time(6), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_clientes_padre AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_clientes_padre", "idt_tipo_cliente", "tipo_persona", "codigo", "razon_social", "tipo_valor", "sector_economico", "estatus" FROM "public"."t_clientes_padre"') as dt( "idt_clientes_padre" int4, "idt_tipo_cliente" int4, "tipo_persona" int4, "codigo" varchar(25), "razon_social" varchar(150), "tipo_valor" varchar(100), "sector_economico" varchar(25), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_cuenta_financiera AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_cuenta_financiera", "idt_tarifa_servicios_group", "idt_presupuesto", "codigo_presupuesto", "codigo_financiero", "descripcion_financiera", "descripcion_presupuestaria" FROM "public"."t_cuenta_financiera"') as dt( "idt_cuenta_financiera" int4, "idt_tarifa_servicios_group" int4, "idt_presupuesto" int4, "codigo_presupuesto" varchar(6), "codigo_financiero" varchar(8), "descripcion_financiera" varchar(100), "descripcion_presupuestaria" varchar(100));
CREATE OR REPLACE VIEW cxc_t_email_masivos AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_email_masivos", "idt_clientes", "idt_facturas", "idt_usuario", "email", "detalle_envio", "fecha_ejecucion" FROM "public"."t_email_masivos"') as dt( "idt_email_masivos" int4, "idt_clientes" int4, "idt_facturas" int4, "idt_usuario" int4, "email" varchar(200), "detalle_envio" varchar(250), "fecha_ejecucion" timestamp(6));
CREATE OR REPLACE VIEW cxc_t_emisiones AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_emisiones", "idt_clientes", "idt_periodo", "idt_tipo_emision", "fecha_emision", "valor_circulacion", "tasa", "monto_pagar", "id_usuario", "fecha_registro", "estatus" FROM "public"."t_emisiones"') as dt( "idt_emisiones" int4, "idt_clientes" int4, "idt_periodo" int4, "idt_tipo_emision" int4, "fecha_emision" date, "valor_circulacion" numeric(16,2), "tasa" numeric(4,2), "monto_pagar" numeric(16,2), "id_usuario" int4, "fecha_registro" date, "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_estado_cuenta AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_estado_cuenta", "idt_cliente", "idt_factura", "idt_recibo", "debito", "credito", "recargo", "saldo", "fecha_generacion" "fecha_vencimiento" "tipo", "estado", "idt_usuario" FROM "public"."t_estado_cuenta"') as dt( "idt_estado_cuenta" int4, "idt_cliente" int4, "idt_factura" int4, "idt_recibo" int4, "debito" numeric(16,2), "credito" numeric(16,2), "recargo" numeric(16,2), "saldo" numeric(16,2),"fecha_generacion" timestamp(6),"fecha_vencimiento" timestamp(6), "tipo" varchar(255), "estado" varchar(255), "idt_usuario" int4);
CREATE OR REPLACE VIEW cxc_t_estado_cuenta_cont AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_estado_cuenta_cont", "idt_estado_cuenta", "idt_factura_detalle", "idt_tarifa_servicio", "idt_catalogo_cuentas_sub", "detalle", "debito", "credito", "saldo" FROM "public"."t_estado_cuenta_cont"') as dt( "idt_estado_cuenta_cont" int4, "idt_estado_cuenta" int4, "idt_factura_detalle" int4, "idt_tarifa_servicio" int4, "idt_catalogo_cuentas_sub" int4, "detalle" varchar(100), "debito" numeric(16,2), "credito" numeric(16,2), "saldo" numeric(16,2));
CREATE OR REPLACE VIEW cxc_t_estado_cuenta_cont_temp AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_estado_cuenta_cont", "idt_estado_cuenta", "idt_factura_detalle", "idt_tarifa_servicio", "idt_catalogo_cuentas_sub", "detalle", "debito", "credito", "saldo" FROM "public"."t_estado_cuenta_cont_temp"') as dt( "idt_estado_cuenta_cont" int4, "idt_estado_cuenta" int4, "idt_factura_detalle" int4, "idt_tarifa_servicio" int4, "idt_catalogo_cuentas_sub" int4, "detalle" varchar(100), "debito" numeric(16,2), "credito" numeric(16,2), "saldo" numeric(16,2));
CREATE OR REPLACE VIEW cxc_t_estado_cuenta_temp AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_estado_cuenta", "idt_cliente", "idt_factura", "idt_recibo", "debito", "credito", "recargo", "saldo", "fecha_generacion", "fecha_vencimiento", "tipo", "estado", "idt_usuario", "usermov", "datemov" FROM "public"."t_estado_cuenta_temp"') as dt( "idt_estado_cuenta" int4, "idt_cliente" int4, "idt_factura" int4, "idt_recibo" int4, "debito" numeric(16,2), "credito" numeric(16,2), "recargo" numeric(16,2), "saldo" numeric(16,2), "fecha_generacion" timestamp(6), "fecha_vencimiento" timestamp(6), "tipo" varchar(255), "estado" varchar(255), "idt_usuario" int4, "usermov" int4, "datemov" timestamp(6));
CREATE OR REPLACE VIEW cxc_t_estatus_fac AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "id", "descripcion", "estatus", "color" FROM "public"."t_estatus_fac"') as dt( "id" int4, "descripcion" varchar(55), "estatus" int4, "color" varchar(10));
CREATE OR REPLACE VIEW cxc_t_factura_detalle AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_factura_detalle", "idt_factura", "cantidad", "idt_tarifa_servicios", "cuenta_desc", "precio_unitario" FROM "public"."t_factura_detalle"') as dt( "idt_factura_detalle" int4, "idt_factura" int4, "cantidad" int4, "idt_tarifa_servicios" int4, "cuenta_desc" varchar(100), "precio_unitario" numeric(16,2));
CREATE OR REPLACE VIEW cxc_t_factura_detalle_temp AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_factura_detalle", "idt_factura", "cantidad", "idt_tarifa_servicios", "cuenta_desc", "precio_unitario" FROM "public"."t_factura_detalle_temp"') as dt( "idt_factura_detalle" int4, "idt_factura" int4, "cantidad" int4, "idt_tarifa_servicios" int4, "cuenta_desc" varchar(100), "precio_unitario" numeric(16,2));
CREATE OR REPLACE VIEW cxc_t_facturas AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_facturas", "idt_clientes", "idt_periodo", "idt_cuenta_venta", "fecha_factura", "fecha_vencimiento", "recargo", "recargo_desc", "itbms", "cantidad_total", "importe_total", "total_factura", "pendiente_fact", "pendiente_ts", "tipo", "id_usuario", "fecha_registro", "hora_registro", "estatus", "justificacion", "fecha_erroneo" "next_fecha_recargo" FROM "public"."t_facturas"') as dt( "idt_facturas" int4, "idt_clientes" int4, "idt_periodo" int4, "idt_cuenta_venta" int4, "fecha_factura" date, "fecha_vencimiento" date, "recargo" numeric(16,2), "recargo_desc" varchar(50), "itbms" numeric(16,2), "cantidad_total" int4, "importe_total" numeric(16,2), "total_factura" numeric(16,2), "pendiente_fact" numeric(16,2), "pendiente_ts" numeric(16,2), "tipo" varchar(255), "id_usuario" int4, "fecha_registro" date, "hora_registro" time(6), "estatus" int4, "justificacion" varchar(200),"fecha_erroneo" timestamp(6),"next_fecha_recargo" date);
CREATE OR REPLACE VIEW cxc_t_facturas_temp AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_facturas", "idt_clientes", "idt_periodo", "idt_cuenta_venta", "fecha_factura", "fecha_vencimiento", "recargo", "recargo_desc", "itbms", "cantidad_total", "importe_total", "total_factura", "pendiente_fact", "pendiente_ts", "tipo", "id_usuario", "fecha_registro", "hora_registro", "estatus", "justificacion", "fecha_erroneo" "next_fecha_recargo" FROM "public"."t_facturas_temp"') as dt( "idt_facturas" int4, "idt_clientes" int4, "idt_periodo" int4, "idt_cuenta_venta" int4, "fecha_factura" date, "fecha_vencimiento" date, "recargo" numeric(16,2), "recargo_desc" varchar(50), "itbms" numeric(16,2), "cantidad_total" int4, "importe_total" numeric(16,2), "total_factura" numeric(16,2), "pendiente_fact" numeric(16,2), "pendiente_ts" numeric(16,2), "tipo" varchar(255), "id_usuario" int4, "fecha_registro" date, "hora_registro" time(6), "estatus" int4, "justificacion" varchar(200),"fecha_erroneo" timestamp(6),"next_fecha_recargo" date);
CREATE OR REPLACE VIEW cxc_t_fecha_corte AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "fecha_corte" FROM "public"."t_fecha_corte"') as dt( "fecha_corte" date);
CREATE OR REPLACE VIEW cxc_t_leyenda AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_leyenda", "anio", "detalle", "estatus" FROM "public"."t_leyenda"') as dt( "idt_leyenda" int4, "anio" int4, "detalle" varchar(100), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_metodo_pago AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_metodo_pago", "descripcion", "estatus" FROM "public"."t_metodo_pago"') as dt( "idt_metodo_pago" int4, "descripcion" varchar(55), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_nota_credito AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_nota_credito", "idt_cliente", "idt_recibo", "idt_factura", "idt_usuario", "monto", "detalle", "fecha_registro", "fecha_sistema" FROM "public"."t_nota_credito"') as dt( "idt_nota_credito" int4, "idt_cliente" int4, "idt_recibo" int4, "idt_factura" int4, "idt_usuario" int4, "monto" numeric(16), "detalle" varchar(20000), "fecha_registro" timestamp(6), "fecha_sistema" timestamp(6));
CREATE OR REPLACE VIEW cxc_t_parentesco AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_parentesco", "descripcion", "estatus" FROM "public"."t_parentesco"') as dt( "idt_parentesco" int4, "descripcion" varchar(25), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_periodo AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_periodo", "descripcion", "rango_dias", "dia_tope", "mes_tope", "mes_tope_desc", "estatus" FROM "public"."t_periodo"') as dt( "idt_periodo" int4, "descripcion" varchar(150), "rango_dias" int4, "dia_tope" int4, "mes_tope" int4, "mes_tope_desc" varchar(20), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_presupuesto AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_presupuesto", "codigo", "descripcion", "estatus" FROM "public"."t_presupuesto"') as dt( "idt_presupuesto" int4, "codigo" varchar(20), "descripcion" varchar(35), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_presupuesto_old AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_presupuesto", "codigo", "descripcion", "estatus" FROM "public"."t_presupuesto_old"') as dt( "idt_presupuesto" int4, "codigo" varchar(20), "descripcion" varchar(35), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_recargo AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_recargo", "descripcion", "tasa", "estatus" FROM "public"."t_recargo"') as dt( "idt_recargo" int4, "descripcion" varchar(100), "tasa" numeric(3,2), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_recargo_x_cliente AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_recargo_x_cliente", "idt_clientes", "idt_recargo", "monto", "fecha", "fecha_registro", "hora_registro", "estatus" FROM "public"."t_recargo_x_cliente"') as dt( "idt_recargo_x_cliente" int4, "idt_clientes" int4, "idt_recargo" int4, "monto" numeric(16,2), "fecha" date, "fecha_registro" date, "hora_registro" time(6), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_recibos AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_recibos", "idt_clientes", "idt_periodo", "idt_facturas", "fecha_pago", "num_cheque", "pago_recibido", "monto_acreditado", "metodo_pago", "cuenta_deposito", "pago_pendiente", "idt_usuario", "fecha_registro", "hora_registro", "estatus", "justificacion", "fecha_erroneo") FROM "public"."t_recibos"') as dt( "idt_recibos" int4, "idt_clientes" int4, "idt_periodo" int4, "idt_facturas" int4,"fecha_pago" date, "num_cheque" varchar(50), "pago_recibido" numeric(16,2), "monto_acreditado" numeric(16,2), "metodo_pago" varchar(10), "cuenta_deposito" int4, "pago_pendiente" numeric(16,2), "idt_usuario" int4,"fecha_registro" date, "hora_registro" time(6), "estatus" int4, "justificacion" varchar(200),"fecha_erroneo" timestamp(6));
CREATE OR REPLACE VIEW cxc_t_recibos_detalle AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_recibos_detalle", "idt_recibos", "cantidad", "cuenta_contable", "cuenta_desc", "precio_unitario" FROM "public"."t_recibos_detalle"') as dt( "idt_recibos_detalle" int4, "idt_recibos" int4, "cantidad" int4, "cuenta_contable" int4, "cuenta_desc" varchar(50), "precio_unitario" numeric(16,2));
CREATE OR REPLACE VIEW cxc_t_rol AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_rol", "url", "li_class", "i_class", "u_class", "nombre", "descripcion", "peso", "estatus", "icon_class" FROM "public"."t_rol"') as dt( "idt_rol" int4, "url" varchar(100), "li_class" varchar(50), "i_class" varchar(50), "u_class" varchar(50), "nombre" varchar(50), "descripcion" varchar(100), "peso" int4, "estatus" int4, "icon_class" varchar(100));
CREATE OR REPLACE VIEW cxc_t_rol_desc AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_rol_desc", "idt_rol", "id_objeto", "nombre", "pagina", "estatus" FROM "public"."t_rol_desc"') as dt( "idt_rol_desc" int4, "idt_rol" int4, "id_objeto" varchar(50), "nombre" varchar(50), "pagina" varchar(100), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_tarifa AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_tarifa", "nombre", "descripcion", "rango_monto", "recargo", "estatus" FROM "public"."t_tarifa"') as dt( "idt_tarifa" int4, "nombre" varchar(50), "descripcion" varchar(150), "rango_monto" varchar(50), "recargo" numeric(3,2), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_tarifa_servicios AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_tarifa_servicios", "idt_tarifa_servicios_group", "idt_catalogo_cuentas_sub", "codigo", "descripcion", "nombre", "clase", "precio", "estatus" FROM "public"."t_tarifa_servicios"') as dt( "idt_tarifa_servicios" int4, "idt_tarifa_servicios_group" int4, "idt_catalogo_cuentas_sub" int4, "codigo" varchar(50), "descripcion" varchar(75), "nombre" varchar(75), "clase" varchar(15), "precio" numeric(16,2), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_tarifa_servicios_group AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_tarifa_servicios_group", "idt_presupuesto", "nombre", "estatus" FROM "public"."t_tarifa_servicios_group"') as dt( "idt_tarifa_servicios_group" int4, "idt_presupuesto" int4, "nombre" varchar(50), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_tarifa_servicios_group_old AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_tarifa_servicios_group", "idt_presupuesto", "nombre", "estatus" FROM "public"."t_tarifa_servicios_group_old"') as dt( "idt_tarifa_servicios_group" int4, "idt_presupuesto" int4, "nombre" varchar(50), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_tarifa_servicios_old AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_tarifa_servicios", "idt_tarifa_servicios_group", "idt_catalogo_cuentas_sub", "codigo", "descripcion", "nombre", "clase", "precio", "estatus" FROM "public"."t_tarifa_servicios_old"') as dt( "idt_tarifa_servicios" int4, "idt_tarifa_servicios_group" int4, "idt_catalogo_cuentas_sub" int4, "codigo" varchar(50), "descripcion" varchar(75), "nombre" varchar(75), "clase" varchar(15), "precio" numeric(16,2), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_tarifa_x_periodo AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_tarifa_x_periodo", "idt_tarifa", "idt_periodo" FROM "public"."t_tarifa_x_periodo"') as dt( "idt_tarifa_x_periodo" int4, "idt_tarifa" int4, "idt_periodo" int4);
CREATE OR REPLACE VIEW cxc_t_tasa AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_tasa", "idt_tipo_cliente", "tasa" FROM "public"."t_tasa"') as dt( "idt_tasa" int4, "idt_tipo_cliente" int4, "tasa" numeric(3,2));
CREATE OR REPLACE VIEW cxc_t_tipo_cliente AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_tipo_cliente", "idt_tarifa", "codigo", "descripcion", "tipo", "estatus" FROM "public"."t_tipo_cliente"') as dt( "idt_tipo_cliente" int4, "idt_tarifa" int4, "codigo" varchar(25), "descripcion" varchar(100), "tipo" varchar(50), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_tipo_cliente_x_tarifa AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_tipo_cliente", "idt_tarifa" FROM "public"."t_tipo_cliente_x_tarifa"') as dt( "idt_tipo_cliente" int4, "idt_tarifa" int4);
CREATE OR REPLACE VIEW cxc_t_tipo_cuentas AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_tipo_cuentas", "descripcion", "estatus" FROM "public"."t_tipo_cuentas"') as dt( "idt_tipo_cuentas" int4, "descripcion" varchar(35), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_tipo_emision AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_tipo_emision", "descripcion", "estatus" FROM "public"."t_tipo_emision"') as dt( "idt_tipo_emision" int4, "descripcion" varchar(25), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_tipo_persona AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_tipo_persona", "descripcion", "estatus" FROM "public"."t_tipo_persona"') as dt( "idt_tipo_persona" int4, "descripcion" varchar(45), "estatus" int4);
CREATE OR REPLACE VIEW cxc_t_usuario AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_usuario", "idt_rol", "usuario", "nombre", "apellido", "email", "contrasena", "salt", "fecha_creado" "creado_por", "imagen", "login", "ultimo_login" "ultimo_ip", "estatus", "hash", "end_hash" "impresora" FROM "public"."t_usuario"') as dt( "idt_usuario" int4, "idt_rol" int4, "usuario" varchar(25), "nombre" varchar(25), "apellido" varchar(25), "email" varchar(100), "contrasena" varchar(250), "salt" varchar(250),"fecha_creado" timestamp(6), "creado_por" int4, "imagen" varchar(100), "login" int4,"ultimo_login" timestamp(6), "ultimo_ip" varchar(25), "estatus" int4, "hash" varchar(250),"end_hash" timestamp(6), "impresora" varchar(150));
CREATE OR REPLACE VIEW cxc_t_usuario_x_rol AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_usuario_x_rol", "idt_usuario", "idt_rol" FROM "public"."t_usuario_x_rol"') as dt( "idt_usuario_x_rol" int4, "idt_usuario" int4, "idt_rol" int4);

/* Migracion por Querys */

INSERT INTO t_tarifas (nombre, descripcion, rango_monto, recargo, estatus, created_at, updated_at)
SELECT nombre, descripcion, rango_monto, recargo, estatus, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM cxc_t_tarifa;

INSERT INTO t_tipo_cliente_tipos (descripcion, estatus, created_at, updated_at)
SELECT DISTINCT TRIM(UPPER(cttc.tipo)), 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM cxc_t_tipo_cliente cttc
ORDER BY 1;

INSERT INTO t_tipo_clientes (codigo, descripcion, t_tipo_cliente_tipo_id, estatus, created_at, updated_at, t_tarifa_id)
SELECT cttc.codigo, cttc.descripcion, tttc.id, cttc.estatus, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, tt."id"
FROM t_tarifas tt
JOIN cxc_t_tarifa ctt on tt.nombre = ctt.nombre
JOIN cxc_t_tipo_cliente cttc on ctt.idt_tarifa = cttc.idt_tarifa
JOIN t_tipo_cliente_tipos tttc on TRIM(UPPER(cttc.tipo)) = tttc.descripcion
ORDER BY 2;

INSERT INTO t_estatuses (estatus, para, descripcion, color, created_at, updated_at)
SELECT 1, 0, 'Inactivo', '#FF0000FF', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
UNION ALL SELECT 1, 0, 'Disponible', '#00FF00FF', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
UNION ALL SELECT 1, 2, 'Con Factura', '#FFFFFFFF', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
UNION ALL SELECT 1, 2, 'Con Recibo', '#FFFFFFFF', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
UNION ALL SELECT 1, 2, 'Pago Pendiente', '#FFFFFFFF', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
UNION ALL SELECT 1, 2, 'Paz y Salvo', '#FFFFFFFF', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
UNION ALL SELECT 1, 1, descripcion, '#00000000', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP FROM cxc_t_estatus_fac;

INSERT INTO t_tipo_personas (descripcion, estatus, created_at, updated_at)
SELECT descripcion, estatus, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP FROM cxc_t_tipo_persona;

UPDATE t_tipo_personas SET descripcion = REPLACE(descripcion, 'Juridicas', 'Jurídicas');

INSERT INTO t_empresa_tipo_valors(descripcion, estatus, created_at, updated_at)
SELECT 'Desconocido', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
UNION ALL (SELECT DISTINCT TRIM(UPPER(tipo_valor)), 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM cxc_t_clientes_padre
WHERE TRIM(UPPER(tipo_valor)) != '' AND TRIM(UPPER(tipo_valor)) != '0'
ORDER BY 1);

INSERT INTO t_empresa_sector_economicos(descripcion, estatus, created_at, updated_at)
SELECT 'Desconocido', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
UNION ALL (SELECT DISTINCT TRIM(UPPER(sector_economico)), 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM cxc_t_clientes_padre
WHERE sector_economico != '' AND sector_economico != '0' AND sector_economico != '11' AND sector_economico != '123'
ORDER BY 1);

INSERT INTO t_tipo_emisions (descripcion, estatus, created_at, updated_at)
SELECT 'Desconocido', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
UNION ALL (SELECT descripcion, estatus, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
from cxc_t_tipo_emision
ORDER BY 1);

INSERT INTO t_periodos (descripcion, estatus, created_at, updated_at, rango_dias, dia_tope, mes_tope)
SELECT 'Desconocido', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '0', 1, 1
UNION ALL (select descripcion, estatus, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, rango_dias, dia_tope, mes_tope 
from cxc_t_periodo
ORDER BY 1);

INSERT INTO t_recargos (descripcion, tasa, estatus, created_at, updated_at)
SELECT 'Desconocido', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
UNION ALL (select descripcion, tasa, estatus, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
from cxc_t_recargo
ORDER BY 1);

INSERT INTO t_empresas (rif, razon_social, direccion_empresa, fax, web, telefono, email, t_empresa_tipo_valor_id, t_empresa_sector_economico_id)
SELECT 
	'RUC'||row_number() OVER (ORDER BY dt.razon_social) AS rif
	, dt.razon_social
	, COALESCE((SELECT TRIM(ctcs.direccion_empresa)
		 from cxc_t_clientes_padre ctcp
	   JOIN cxc_t_clientes ctcs ON ctcp.idt_clientes_padre = ctcs.idt_cliente_padre AND UPPER(TRIM(ctcp.razon_social)) = dt.razon_social
		 WHERE TRIM(ctcs.direccion_empresa) <> '0' AND TRIM(ctcs.direccion_empresa) <> ''
		 LIMIT 1 ), 'Desconocida') as direccion
	, COALESCE((SELECT TRIM(ctcs.fax)
		 from cxc_t_clientes_padre ctcp
	   JOIN cxc_t_clientes ctcs ON ctcp.idt_clientes_padre = ctcs.idt_cliente_padre AND UPPER(TRIM(ctcp.razon_social)) = dt.razon_social
		 WHERE TRIM(ctcs.fax) <> '0' AND TRIM(ctcs.fax) <> ''
		 LIMIT 1 ), null) as fax
  , COALESCE((SELECT TRIM(ctcs.web)
		 from cxc_t_clientes_padre ctcp
	   JOIN cxc_t_clientes ctcs ON ctcp.idt_clientes_padre = ctcs.idt_cliente_padre AND UPPER(TRIM(ctcp.razon_social)) = dt.razon_social
		 WHERE TRIM(ctcs.web) <> '0' AND TRIM(ctcs.web) <> ''
		 LIMIT 1 ), null) as web
  , COALESCE((SELECT TRIM(ctcs.telefono)
		 from cxc_t_clientes_padre ctcp
	   JOIN cxc_t_clientes ctcs ON ctcp.idt_clientes_padre = ctcs.idt_cliente_padre AND UPPER(TRIM(ctcp.razon_social)) = dt.razon_social
		 WHERE TRIM(ctcs.telefono) <> '0' AND TRIM(ctcs.telefono) <> ''
		 LIMIT 1 ), '0') as telefono
  , COALESCE((SELECT TRIM(ctcs.email)
		 from cxc_t_clientes_padre ctcp
	   JOIN cxc_t_clientes ctcs ON ctcp.idt_clientes_padre = ctcs.idt_cliente_padre AND UPPER(TRIM(ctcp.razon_social)) = dt.razon_social
		 WHERE TRIM(ctcs.email) <> '0' AND TRIM(ctcs.email) <> ''
		 LIMIT 1 ), 'desconocido@svm.com') as email
	, COALESCE(dt.tipo_valor, 1) tipo_valor
	, COALESCE(dt.sector_economico, 1) sector_economico
FROM (
	SELECT 
	  UPPER(TRIM(ctcp.razon_social)) as razon_social		
		, tetv.id as tipo_valor
		, tese.id as sector_economico
	FROM cxc_t_clientes_padre ctcp
	LEFT JOIN t_empresa_sector_economicos tese on upper(trim(ctcp.sector_economico)) = tese.descripcion
	LEFT JOIN t_empresa_tipo_valors tetv on upper(trim(ctcp.tipo_valor)) = tetv.descripcion
	WHERE ctcp.tipo_persona = 1
	GROUP BY 1,2,3
) dt;

INSERT INTO t_personas (cedula, nombre, apellido, num_licencia, created_at, updated_at, t_empresa_id, cargo, telefono, email, direccion)
SELECT 
  'CED'||row_number() OVER (ORDER BY dt.nombre) AS cedula	
	, COALESCE(CASE
		WHEN dt.apellido IS NOT NULL THEN dt.nombre
		WHEN array_length(res, 1) = 1 
			OR array_length(res, 1) = 2 
			OR array_length(res, 1) = 3 
			OR (array_length(res, 1) = 4 AND lower(trim(res[2])) = 'de' AND lower(trim(res[3])) = 'la')
			OR (array_length(res, 1) = 4 AND lower(trim(res[2])) = 'del')
			OR (array_length(res, 1) = 5 AND lower(trim(res[2])) = 'de')
		THEN res[1] 
		WHEN array_length(res, 1) = 4 OR array_length(res, 1) = 5 THEN res[1] || ' ' || res[2]		
		WHEN array_length(res, 1) = 6 OR array_length(res, 1) = 7 THEN res[1] || ' ' || res[2] || ' ' || res[3]
		WHEN array_length(res, 1) = 8 THEN res[1] || ' ' || res[2] || ' ' || res[3] || ' ' || res[4]
		ELSE '-' END, '-') nombre
, COALESCE(CASE 
		WHEN dt.apellido IS NOT NULL THEN dt.apellido
		WHEN array_length(res, 1) = 2 THEN res[2] 
		WHEN array_length(res, 1) = 3 THEN res[2] || ' ' || res[3]
		WHEN array_length(res, 1) = 4 AND (
				(lower(trim(res[2])) = 'de' AND lower(trim(res[3])) = 'la') 
			OR lower(trim(res[2])) = 'del') THEN res[2] || ' ' || res[3] || ' ' || res[4]
		WHEN array_length(res, 1) = 4 THEN res[3] || ' ' || res[4]
		WHEN (array_length(res, 1) = 5 AND lower(trim(res[2])) = 'de') THEN res[2] || ' ' || res[3] || ' ' || res[4] || ' ' || res[5]
		WHEN array_length(res, 1) = 5 THEN res[3] || ' ' || res[4] || res[5]
		WHEN array_length(res, 1) = 6 OR array_length(res, 1) = 7 THEN res[4] || ' ' || res[5] || ' ' || res[6] || ' ' || res[7]
		WHEN array_length(res, 1) = 8 THEN res[5] || ' ' || res[6] || ' ' || res[7] || ' ' || res[8]
		ELSE '-' END, '-') apellido
	, dt.num_licencia
	, CURRENT_TIMESTAMP created_at
	, CURRENT_TIMESTAMP updated_at
	, null empresa
	, dt.cargo
	, COALESCE(dt.telefono, '0') telefono
	, COALESCE(dt.email, 'desconocido@svm.com') email
	, COALESCE(dt.direccion_empresa, 'Desconocida') direccion
FROM (SELECT 
	  CASE WHEN TRIM(ctcs.nombre) = '' OR TRIM(ctcs.nombre) = '0' THEN NULL ELSE UPPER(TRIM(ctcs.nombre)) END nombre
	, CASE WHEN TRIM(ctcs.apellido) = '' OR TRIM(ctcs.apellido) = '0' THEN NULL ELSE UPPER(TRIM(ctcs.apellido)) END apellido
	, 0 num_licencia --ctcs.num_licencia
	, CASE WHEN TRIM(ctcs.telefono) = '' OR TRIM(ctcs.telefono) = '0' THEN NULL ELSE TRIM(ctcs.telefono) END telefono
  , CASE WHEN TRIM(ctcs.email) = '' OR TRIM(ctcs.email) = '0' THEN NULL ELSE TRIM(ctcs.email) END email
  , CASE WHEN TRIM(ctcs.direccion_empresa) = '' OR TRIM(ctcs.direccion_empresa) = '0' THEN NULL ELSE TRIM(ctcs.direccion_empresa) END direccion_empresa
	, CASE WHEN TRIM(ctcs.cargo) = '' OR TRIM(ctcs.cargo) = '0' THEN NULL ELSE TRIM(ctcs.cargo) END cargo
FROM cxc_t_clientes ctcs
LEFT JOIN cxc_t_tipo_cliente cttc ON ctcs.idt_tipo_cliente = cttc.idt_tipo_cliente
WHERE NOT (ctcs.nombre ~ '(INC\.{0,1}|Inc\.|S\.\s{0,1}A\.{0,1}|Corp|[0-9]|\*|S\.R\.L\.)' OR ctcs.apellido ~ '(CORP\.{0,1}|S\.A\.{0,1})') AND ctcs.idt_cliente_padre = 360
GROUP BY 1,2,3,4,5,6,7
ORDER BY 1
) dt
LEFT JOIN regexp_split_to_array(trim(dt.nombre), '(?:[\s,\.]+)') res ON 1 = 1;

INSERT INTO t_clientes (codigo, t_estatus_id, created_at, updated_at, persona_id, persona_type)
SELECT 
	'CLI'||row_number() OVER (ORDER BY dt.status) AS codigo
	, dt.status, dt.created_at, dt.updated_at, dt."id", dt."type"
FROM (
  SELECT 2 status, CURRENT_TIMESTAMP created_at, CURRENT_TIMESTAMP updated_at, rw."id", 'TEmpresa' "type" FROM t_empresas rw
	UNION ALL SELECT 2 status, CURRENT_TIMESTAMP created_at, CURRENT_TIMESTAMP updated_at, rw."id", 'TPersona' "type" FROM t_personas rw
)	dt;

INSERT INTO t_tarifa_servicios (codigo, descripcion, nombre, clase, precio, estatus, created_at, updated_at)
select ctts.codigo, ctts.descripcion, ctts.nombre, ctts.clase, ctts.precio, ctts.estatus, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
from cxc_t_tarifa_servicios ctts;

-- Ultimo registro
INSERT INTO schema_migrations VALUES('0');