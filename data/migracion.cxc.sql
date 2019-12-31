/* Verificar si dblink esta disponible. */
SELECT pg_namespace.nspname, pg_proc.proname FROM pg_proc, pg_namespace WHERE pg_proc.pronamespace=pg_namespace.oid AND pg_proc.proname LIKE '%dblink%';
/* Verificar conexion. */
SELECT dblink_connect('cxc_server');

CREATE MATERIALIZED VIEW cxc_login_attempts AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_usuario", "time" FROM "public"."login_attempts"') as dt( "idt_usuario" int4, "time" varchar(30));
CREATE MATERIALIZED VIEW cxc_t_caja AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_caja", "idt_recibos", "pago_recibido", "monto_factura", "vuelto", "idt_usuario", "fecha", "tipo" FROM "public"."t_caja"') as dt( "idt_caja" int4, "idt_recibos" int4, "pago_recibido" numeric(16,2), "monto_factura" numeric(16,2), "vuelto" numeric(10), "idt_usuario" int4, "fecha" timestamp(6), "tipo" varchar(15));
CREATE MATERIALIZED VIEW cxc_t_catalogo_cuentas AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_catalogo_cuentas", "idt_tipo_cuentas", "codigo", "descripcion", "estatus" FROM "public"."t_catalogo_cuentas"') as dt( "idt_catalogo_cuentas" int4, "idt_tipo_cuentas" int4, "codigo" varchar(15), "descripcion" varchar(35), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_catalogo_cuentas_old AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_catalogo_cuentas", "idt_tipo_cuentas", "codigo", "descripcion", "estatus" FROM "public"."t_catalogo_cuentas_old"') as dt( "idt_catalogo_cuentas" int4, "idt_tipo_cuentas" int4, "codigo" varchar(15), "descripcion" varchar(35), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_catalogo_cuentas_sub AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_catalogo_cuentas_sub", "idt_catalogo", "idt_presupuesto", "codigo", "descripcion", "estatus" FROM "public"."t_catalogo_cuentas_sub"') as dt( "idt_catalogo_cuentas_sub" int4, "idt_catalogo" int4, "idt_presupuesto" int4, "codigo" varchar(15), "descripcion" varchar(55), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_catalogo_cuentas_sub_old AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_catalogo_cuentas_sub", "idt_catalogo", "idt_presupuesto", "codigo", "descripcion", "estatus" FROM "public"."t_catalogo_cuentas_sub_old"') as dt( "idt_catalogo_cuentas_sub" int4, "idt_catalogo" int4, "idt_presupuesto" int4, "codigo" varchar(15), "descripcion" varchar(55), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_categoria AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_categoria", "descripcion", "formulario", "estatus" FROM "public"."t_categoria"') as dt( "idt_categoria" int4, "descripcion" varchar(50), "formulario" varchar(25), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_cliente_x_tarifa AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_cliente_x_tarifa", "idt_cliente", "idt_periodo", "idt_tarifa", "monto", "fecha", "fecha_registro", "hora_registro", "estatus" FROM "public"."t_cliente_x_tarifa"') as dt( "idt_cliente_x_tarifa" int4, "idt_cliente" int4, "idt_periodo" int4, "idt_tarifa" int4, "monto" numeric(16,2),"fecha" date, "fecha_registro" date, "hora_registro" time(6), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_clientes AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_clientes", "idt_tipo_cliente", "idt_tipo_emision", "cuenta_venta", "idt_cliente_padre", "idt_catalogo_cuentas", "codigo", "prospecto", "prospecto_date_in", "prospecto_date_out", "resolucion", "nombre", "apellido", "cedula", "empresa", "cargo", "direccion_empresa", "telefono", "fax", "email", "web", "num_licencia", "fecha_resolucion", "fecha_notificacion", "fecha_vencimiento", "fecha_vencimiento_fact", "monto_emision1", "idt_usuario", "fecha_registro", "hora_registro", "estatus" FROM "public"."t_clientes"') as dt( "idt_clientes" int4, "idt_tipo_cliente" int4, "idt_tipo_emision" int4, "cuenta_venta" int4, "idt_cliente_padre" int4, "idt_catalogo_cuentas" int4, "codigo" varchar(45),"prospecto" int4,"prospecto_date_in" date, "prospecto_date_out" date, "resolucion" varchar(100), "nombre" varchar(200), "apellido" varchar(50), "cedula" varchar(25), "empresa" varchar(60), "cargo" varchar(30), "direccion_empresa" varchar(75), "telefono" varchar(15), "fax" varchar(15), "email" varchar(200), "web" varchar(65), "num_licencia" int4,"fecha_resolucion" date,"fecha_notificacion" date, "fecha_vencimiento" date, "fecha_vencimiento_fact" date, "monto_emision1" numeric(16,2), "idt_usuario" int4, "fecha_registro" date, "hora_registro" time(6), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_cliente_matsh AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_clientes", "ID_CASA_VALOR" FROM "public"."t_cliente_matsh"') as dt( "idt_clientes" int4, "ID_CASA_VALOR" int4);
CREATE MATERIALIZED VIEW cxc_t_clientes_padre AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_clientes_padre", "idt_tipo_cliente", "tipo_persona", "codigo", "razon_social", "tipo_valor", "sector_economico", "estatus" FROM "public"."t_clientes_padre"') as dt( "idt_clientes_padre" int4, "idt_tipo_cliente" int4, "tipo_persona" int4, "codigo" varchar(25), "razon_social" varchar(150), "tipo_valor" varchar(100), "sector_economico" varchar(25), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_cuenta_financiera AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_cuenta_financiera", "idt_tarifa_servicios_group", "idt_presupuesto", "codigo_presupuesto", "codigo_financiero", "descripcion_financiera", "descripcion_presupuestaria" FROM "public"."t_cuenta_financiera"') as dt( "idt_cuenta_financiera" int4, "idt_tarifa_servicios_group" int4, "idt_presupuesto" int4, "codigo_presupuesto" varchar(6), "codigo_financiero" varchar(8), "descripcion_financiera" varchar(100), "descripcion_presupuestaria" varchar(100));
CREATE MATERIALIZED VIEW cxc_t_email_masivos AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_email_masivos", "idt_clientes", "idt_facturas", "idt_usuario", "email", "detalle_envio", "fecha_ejecucion" FROM "public"."t_email_masivos"') as dt( "idt_email_masivos" int4, "idt_clientes" int4, "idt_facturas" int4, "idt_usuario" int4, "email" varchar(200), "detalle_envio" varchar(250), "fecha_ejecucion" timestamp(6));
CREATE MATERIALIZED VIEW cxc_t_emisiones AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_emisiones", "idt_clientes", "idt_periodo", "idt_tipo_emision", "fecha_emision", "valor_circulacion", "tasa", "monto_pagar", "id_usuario", "fecha_registro", "estatus" FROM "public"."t_emisiones"') as dt( "idt_emisiones" int4, "idt_clientes" int4, "idt_periodo" int4, "idt_tipo_emision" int4, "fecha_emision" date, "valor_circulacion" numeric(16,2), "tasa" numeric(4,2), "monto_pagar" numeric(16,2), "id_usuario" int4, "fecha_registro" date, "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_estado_cuenta AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_estado_cuenta", "idt_cliente", "idt_factura", "idt_recibo", "debito", "credito", "recargo", "saldo", "fecha_generacion", "fecha_vencimiento", "tipo", "estado", "idt_usuario" FROM "public"."t_estado_cuenta"') as dt( "idt_estado_cuenta"	int4, "idt_cliente"	int4, "idt_factura"	int4, "idt_recibo"	int4, "debito"	numeric(16,2), "credito"	numeric(16,2), "recargo"	numeric(16,2), "saldo"	numeric(16,2), "fecha_generacion"	timestamp(6), "fecha_vencimiento"	timestamp(6), "tipo"	varchar(255), "estado"	varchar(255), "idt_usuario"	int4);
CREATE MATERIALIZED VIEW cxc_t_estado_cuenta_cont AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_estado_cuenta_cont", "idt_estado_cuenta", "idt_factura_detalle", "idt_tarifa_servicio", "idt_catalogo_cuentas_sub", "detalle", "debito", "credito", "saldo" FROM "public"."t_estado_cuenta_cont"') as dt( "idt_estado_cuenta_cont" int4, "idt_estado_cuenta" int4, "idt_factura_detalle" int4, "idt_tarifa_servicio" int4, "idt_catalogo_cuentas_sub" int4, "detalle" varchar(100), "debito" numeric(16,2), "credito" numeric(16,2), "saldo" numeric(16,2));
CREATE MATERIALIZED VIEW cxc_t_estado_cuenta_cont_temp AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_estado_cuenta_cont", "idt_estado_cuenta", "idt_factura_detalle", "idt_tarifa_servicio", "idt_catalogo_cuentas_sub", "detalle", "debito", "credito", "saldo" FROM "public"."t_estado_cuenta_cont_temp"') as dt( "idt_estado_cuenta_cont" int4, "idt_estado_cuenta" int4, "idt_factura_detalle" int4, "idt_tarifa_servicio" int4, "idt_catalogo_cuentas_sub" int4, "detalle" varchar(100), "debito" numeric(16,2), "credito" numeric(16,2), "saldo" numeric(16,2));
CREATE MATERIALIZED VIEW cxc_t_estado_cuenta_temp AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_estado_cuenta", "idt_cliente", "idt_factura", "idt_recibo", "debito", "credito", "recargo", "saldo", "fecha_generacion", "fecha_vencimiento", "tipo", "estado", "idt_usuario", "usermov", "datemov" FROM "public"."t_estado_cuenta_temp"') as dt( "idt_estado_cuenta" int4, "idt_cliente" int4, "idt_factura" int4, "idt_recibo" int4, "debito" numeric(16,2), "credito" numeric(16,2), "recargo" numeric(16,2), "saldo" numeric(16,2), "fecha_generacion" timestamp(6), "fecha_vencimiento" timestamp(6), "tipo" varchar(255), "estado" varchar(255), "idt_usuario" int4, "usermov" int4, "datemov" timestamp(6));
CREATE MATERIALIZED VIEW cxc_t_estatus_fac AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "id", "descripcion", "estatus", "color" FROM "public"."t_estatus_fac"') as dt( "id" int4, "descripcion" varchar(55), "estatus" int4, "color" varchar(10));
CREATE MATERIALIZED VIEW cxc_t_factura_detalle AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_factura_detalle", "idt_factura", "cantidad", "idt_tarifa_servicios", "cuenta_desc", "precio_unitario" FROM "public"."t_factura_detalle"') as dt( "idt_factura_detalle" int4, "idt_factura" int4, "cantidad" int4, "idt_tarifa_servicios" int4, "cuenta_desc" varchar(100), "precio_unitario" numeric(16,2));
CREATE MATERIALIZED VIEW cxc_t_factura_detalle_temp AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_factura_detalle", "idt_factura", "cantidad", "idt_tarifa_servicios", "cuenta_desc", "precio_unitario" FROM "public"."t_factura_detalle_temp"') as dt( "idt_factura_detalle" int4, "idt_factura" int4, "cantidad" int4, "idt_tarifa_servicios" int4, "cuenta_desc" varchar(100), "precio_unitario" numeric(16,2));
CREATE MATERIALIZED VIEW cxc_t_facturas AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_facturas", "idt_clientes", "idt_periodo", "idt_cuenta_venta", "fecha_factura", "fecha_vencimiento", "recargo", "recargo_desc", "itbms", "cantidad_total", "importe_total", "total_factura", "pendiente_fact", "pendiente_ts", "tipo", "id_usuario", "fecha_registro", "hora_registro", "estatus", "justificacion", "fecha_erroneo", "next_fecha_recargo" FROM "public"."t_facturas"') as dt( "idt_facturas"	int4, "idt_clientes"	int4, "idt_periodo"	int4, "idt_cuenta_venta"	int4, "fecha_factura"	date, "fecha_vencimiento"	date, "recargo"	numeric(16,2), "recargo_desc"	varchar(50), "itbms"	numeric(16,2), "cantidad_total"	int4, "importe_total"	numeric(16,2), "total_factura"	numeric(16,2), "pendiente_fact"	numeric(16,2), "pendiente_ts"	numeric(16,2), "tipo"	varchar(255), "id_usuario"	int4, "fecha_registro"	date, "hora_registro"	time(6), "estatus"	int4, "justificacion"	varchar(200), "fecha_erroneo"	timestamp(6), "next_fecha_recargo"	date);
CREATE MATERIALIZED VIEW cxc_t_facturas_temp AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_facturas", "idt_clientes", "idt_periodo", "idt_cuenta_venta", "fecha_factura", "fecha_vencimiento", "recargo", "recargo_desc", "itbms", "cantidad_total", "importe_total", "total_factura", "pendiente_fact", "pendiente_ts", "tipo", "id_usuario", "fecha_registro", "hora_registro", "estatus", "justificacion", "fecha_erroneo", "next_fecha_recargo" FROM "public"."t_facturas_temp"') as dt( "idt_facturas"	int4, "idt_clientes"	int4, "idt_periodo"	int4, "idt_cuenta_venta"	int4, "fecha_factura"	date, "fecha_vencimiento"	date, "recargo"	numeric(16,2), "recargo_desc"	varchar(50), "itbms"	numeric(16,2), "cantidad_total"	int4, "importe_total"	numeric(16,2), "total_factura"	numeric(16,2), "pendiente_fact"	numeric(16,2), "pendiente_ts"	numeric(16,2), "tipo"	varchar(255), "id_usuario"	int4, "fecha_registro"	date, "hora_registro"	time(6), "estatus"	int4, "justificacion"	varchar(200), "fecha_erroneo"	timestamp(6), "next_fecha_recargo"	date);
CREATE MATERIALIZED VIEW cxc_t_fecha_corte AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "fecha_corte" FROM "public"."t_fecha_corte"') as dt( "fecha_corte" date);
CREATE MATERIALIZED VIEW cxc_t_leyenda AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_leyenda", "anio", "detalle", "estatus" FROM "public"."t_leyenda"') as dt( "idt_leyenda" int4, "anio" int4, "detalle" varchar(100), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_metodo_pago AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_metodo_pago", "descripcion", "estatus" FROM "public"."t_metodo_pago"') as dt( "idt_metodo_pago" int4, "descripcion" varchar(55), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_nota_credito AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_nota_credito", "idt_cliente", "idt_recibo", "idt_factura", "idt_usuario", "monto", "detalle", "fecha_registro", "fecha_sistema" FROM "public"."t_nota_credito"') as dt( "idt_nota_credito" int4, "idt_cliente" int4, "idt_recibo" int4, "idt_factura" int4, "idt_usuario" int4, "monto" numeric(16), "detalle" varchar(20000), "fecha_registro" timestamp(6), "fecha_sistema" timestamp(6));
CREATE MATERIALIZED VIEW cxc_t_parentesco AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_parentesco", "descripcion", "estatus" FROM "public"."t_parentesco"') as dt( "idt_parentesco" int4, "descripcion" varchar(25), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_periodo AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_periodo", "descripcion", "rango_dias", "dia_tope", "mes_tope", "mes_tope_desc", "estatus" FROM "public"."t_periodo"') as dt( "idt_periodo" int4, "descripcion" varchar(150), "rango_dias" int4, "dia_tope" int4, "mes_tope" int4, "mes_tope_desc" varchar(20), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_presupuesto AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_presupuesto", "codigo", "descripcion", "estatus" FROM "public"."t_presupuesto"') as dt( "idt_presupuesto" int4, "codigo" varchar(20), "descripcion" varchar(35), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_presupuesto_old AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_presupuesto", "codigo", "descripcion", "estatus" FROM "public"."t_presupuesto_old"') as dt( "idt_presupuesto" int4, "codigo" varchar(20), "descripcion" varchar(35), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_recargo AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_recargo", "descripcion", "tasa", "estatus" FROM "public"."t_recargo"') as dt( "idt_recargo" int4, "descripcion" varchar(100), "tasa" numeric(3,2), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_recargo_x_cliente AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_recargo_x_cliente", "idt_clientes", "idt_recargo", "monto", "fecha", "fecha_registro", "hora_registro", "estatus" FROM "public"."t_recargo_x_cliente"') as dt( "idt_recargo_x_cliente" int4, "idt_clientes" int4, "idt_recargo" int4, "monto" numeric(16,2), "fecha" date, "fecha_registro" date, "hora_registro" time(6), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_recibos AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_recibos", "idt_clientes", "idt_periodo", "idt_facturas", "fecha_pago", "num_cheque", "pago_recibido", "monto_acreditado", "metodo_pago", "cuenta_deposito", "pago_pendiente", "idt_usuario", "fecha_registro", "hora_registro", "estatus", "justificacion", "fecha_erroneo" FROM "public"."t_recibos"') as dt( "idt_recibos"	int4, "idt_clientes"	int4, "idt_periodo"	int4, "idt_facturas"	int4, "fecha_pago"	date, "num_cheque"	varchar(50), "pago_recibido"	numeric(16,2), "monto_acreditado"	numeric(16,2), "metodo_pago"	varchar(10), "cuenta_deposito"	int4, "pago_pendiente"	numeric(16,2), "idt_usuario"	int4, "fecha_registro"	date, "hora_registro"	time, "estatus"	int4, "justificacion"	varchar(200), "fecha_erroneo"	timestamp);
CREATE MATERIALIZED VIEW cxc_t_recibos_detalle AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_recibos_detalle", "idt_recibos", "cantidad", "cuenta_contable", "cuenta_desc", "precio_unitario" FROM "public"."t_recibos_detalle"') as dt( "idt_recibos_detalle" int4, "idt_recibos" int4, "cantidad" int4, "cuenta_contable" int4, "cuenta_desc" varchar(50), "precio_unitario" numeric(16,2));
CREATE MATERIALIZED VIEW cxc_t_rol AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_rol", "url", "li_class", "i_class", "u_class", "nombre", "descripcion", "peso", "estatus", "icon_class" FROM "public"."t_rol"') as dt( "idt_rol" int4, "url" varchar(100), "li_class" varchar(50), "i_class" varchar(50), "u_class" varchar(50), "nombre" varchar(50), "descripcion" varchar(100), "peso" int4, "estatus" int4, "icon_class" varchar(100));
CREATE MATERIALIZED VIEW cxc_t_rol_desc AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_rol_desc", "idt_rol", "id_objeto", "nombre", "pagina", "estatus" FROM "public"."t_rol_desc"') as dt( "idt_rol_desc" int4, "idt_rol" int4, "id_objeto" varchar(50), "nombre" varchar(50), "pagina" varchar(100), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_tarifa AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_tarifa", "nombre", "descripcion", "rango_monto", "recargo", "estatus" FROM "public"."t_tarifa"') as dt( "idt_tarifa" int4, "nombre" varchar(50), "descripcion" varchar(150), "rango_monto" varchar(50), "recargo" numeric(3,2), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_tarifa_servicios AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_tarifa_servicios", "idt_tarifa_servicios_group", "idt_catalogo_cuentas_sub", "codigo", "descripcion", "nombre", "clase", "precio", "estatus" FROM "public"."t_tarifa_servicios"') as dt( "idt_tarifa_servicios" int4, "idt_tarifa_servicios_group" int4, "idt_catalogo_cuentas_sub" int4, "codigo" varchar(50), "descripcion" varchar(75), "nombre" varchar(75), "clase" varchar(15), "precio" numeric(16,2), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_tarifa_servicios_group AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_tarifa_servicios_group", "idt_presupuesto", "nombre", "estatus" FROM "public"."t_tarifa_servicios_group"') as dt( "idt_tarifa_servicios_group" int4, "idt_presupuesto" int4, "nombre" varchar(50), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_tarifa_servicios_group_old AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_tarifa_servicios_group", "idt_presupuesto", "nombre", "estatus" FROM "public"."t_tarifa_servicios_group_old"') as dt( "idt_tarifa_servicios_group" int4, "idt_presupuesto" int4, "nombre" varchar(50), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_tarifa_servicios_old AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_tarifa_servicios", "idt_tarifa_servicios_group", "idt_catalogo_cuentas_sub", "codigo", "descripcion", "nombre", "clase", "precio", "estatus" FROM "public"."t_tarifa_servicios_old"') as dt( "idt_tarifa_servicios" int4, "idt_tarifa_servicios_group" int4, "idt_catalogo_cuentas_sub" int4, "codigo" varchar(50), "descripcion" varchar(75), "nombre" varchar(75), "clase" varchar(15), "precio" numeric(16,2), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_tarifa_x_periodo AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_tarifa_x_periodo", "idt_tarifa", "idt_periodo" FROM "public"."t_tarifa_x_periodo"') as dt( "idt_tarifa_x_periodo" int4, "idt_tarifa" int4, "idt_periodo" int4);
CREATE MATERIALIZED VIEW cxc_t_tasa AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_tasa", "idt_tipo_cliente", "tasa" FROM "public"."t_tasa"') as dt( "idt_tasa" int4, "idt_tipo_cliente" int4, "tasa" numeric(3,2));
CREATE MATERIALIZED VIEW cxc_t_tipo_cliente AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_tipo_cliente", "idt_tarifa", "codigo", "descripcion", "tipo", "estatus" FROM "public"."t_tipo_cliente"') as dt( "idt_tipo_cliente" int4, "idt_tarifa" int4, "codigo" varchar(25), "descripcion" varchar(100), "tipo" varchar(50), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_tipo_cliente_x_tarifa AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_tipo_cliente", "idt_tarifa" FROM "public"."t_tipo_cliente_x_tarifa"') as dt( "idt_tipo_cliente" int4, "idt_tarifa" int4);
CREATE MATERIALIZED VIEW cxc_t_tipo_cuentas AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_tipo_cuentas", "descripcion", "estatus" FROM "public"."t_tipo_cuentas"') as dt( "idt_tipo_cuentas" int4, "descripcion" varchar(35), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_tipo_emision AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_tipo_emision", "descripcion", "estatus" FROM "public"."t_tipo_emision"') as dt( "idt_tipo_emision" int4, "descripcion" varchar(25), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_tipo_persona AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_tipo_persona", "descripcion", "estatus" FROM "public"."t_tipo_persona"') as dt( "idt_tipo_persona" int4, "descripcion" varchar(45), "estatus" int4);
CREATE MATERIALIZED VIEW cxc_t_usuario AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_usuario", "idt_rol", "usuario", "nombre", "apellido", "email", "contrasena", "salt", "fecha_creado", "creado_por", "imagen", "login", "ultimo_login", "ultimo_ip", "estatus", "hash", "end_hash", "impresora" FROM "public"."t_usuario"') as dt( "idt_usuario" int4, "idt_rol" int4, "usuario" varchar(25), "nombre" varchar(25), "apellido" varchar(25), "email" varchar(100), "contrasena" varchar(250), "salt" varchar(250), "fecha_creado" timestamp(6), "creado_por" int4, "imagen" varchar(100), "login" int4, "ultimo_login" timestamp(6), "ultimo_ip" varchar(25), "estatus" int4, "hash" varchar(250), "end_hash" timestamp(6), "impresora" varchar(150));
CREATE MATERIALIZED VIEW cxc_t_usuario_x_rol AS SELECT dt.* FROM dblink('cxc_server', 'SELECT "idt_usuario_x_rol", "idt_usuario", "idt_rol" FROM "public"."t_usuario_x_rol"') as dt( "idt_usuario_x_rol" int4, "idt_usuario" int4, "idt_rol" int4);

/* Migracion por Querys */

CREATE MATERIALIZED VIEW tarifas_normalizados AS
SELECT 
	row_number() OVER (ORDER BY dt.descripcion) AS prediction_id
	, dt.*
FROM (
	SELECT 'Desconocida' nombre, 'Desconocida' descripcion, '0' rango_monto, 0 recargo, 0 estatus, CURRENT_TIMESTAMP created_at, CURRENT_TIMESTAMP updated_at
	UNION ALL (SELECT nombre, descripcion, rango_monto, recargo, estatus, CURRENT_TIMESTAMP created_at, CURRENT_TIMESTAMP updated_at
		FROM cxc_t_tarifa)
) dt;

INSERT INTO t_tarifas (nombre, descripcion, rango_monto, recargo, estatus, created_at, updated_at)
SELECT nombre, descripcion, rango_monto, recargo, estatus, created_at, updated_at
FROM tarifas_normalizados;

CREATE MATERIALIZED VIEW tipo_cliente_tipos_normalizados AS
SELECT 
	row_number() OVER (ORDER BY dt.descripcion) AS prediction_id
	, dt.*
FROM (
	SELECT 'Desconocida' descripcion, 0 estatus, CURRENT_TIMESTAMP created_at, CURRENT_TIMESTAMP updated_at
	UNION ALL (SELECT DISTINCT TRIM(UPPER(cttc.tipo)) descripcion, 1 estatus, CURRENT_TIMESTAMP created_at, CURRENT_TIMESTAMP updated_at
	FROM cxc_t_tipo_cliente cttc
	ORDER BY 1)
) dt;

INSERT INTO t_tipo_cliente_tipos (descripcion, estatus, created_at, updated_at)
SELECT descripcion, estatus, created_at, updated_at
FROM tipo_cliente_tipos_normalizados;

CREATE MATERIALIZED VIEW tipo_clientes_normalizados AS
SELECT 
	row_number() OVER (ORDER BY dt.codigo) AS prediction_id
	, dt.*
FROM (
SELECT '00' codigo, 'Desconocido' descripcion, 1 t_tipo_cliente_tipo_id, 0 estatus, CURRENT_TIMESTAMP created_at, CURRENT_TIMESTAMP updated_at, 1 t_tarifa_id
UNION ALL (SELECT cttc.codigo, cttc.descripcion, tttc.id, cttc.estatus, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, tt."id"
	FROM t_tarifas tt
	JOIN cxc_t_tarifa ctt on tt.nombre = ctt.nombre
	JOIN cxc_t_tipo_cliente cttc on ctt.idt_tarifa = cttc.idt_tarifa
	JOIN t_tipo_cliente_tipos tttc on TRIM(UPPER(cttc.tipo)) = tttc.descripcion
	ORDER BY 2)
) dt;

INSERT INTO t_tipo_clientes (codigo, descripcion, t_tipo_cliente_tipo_id, estatus, created_at, updated_at, t_tarifa_id)
SELECT codigo, descripcion, t_tipo_cliente_tipo_id, estatus, created_at, updated_at, t_tarifa_id
FROM tipo_clientes_normalizados;

CREATE MATERIALIZED VIEW estatuses_normalizados AS
SELECT
	row_number() OVER (ORDER BY 1, 2) AS prediction_id
	, dt.estatus
	, dt.para
	, dt.descripcion
	, dt.color
	, dt.created_at
	, dt.updated_at
	, dt.prev_id
FROM (
	SELECT 1 estatus, 0 para, 'Inactivo' descripcion, '#FF0000FF' color, CURRENT_TIMESTAMP created_at, CURRENT_TIMESTAMP updated_at, 0 prev_id
	UNION ALL SELECT 1, 0, 'Disponible', '#00FF00FF', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 0
	UNION ALL SELECT 1, 2, 'Con Factura', '#FFFFFFFF', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 0
	UNION ALL SELECT 1, 2, 'Con Recibo', '#FFFFFFFF', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 0
	UNION ALL SELECT 1, 2, 'Pago Pendiente', '#FFFFFFFF', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 0
	UNION ALL SELECT 1, 2, 'Paz y Salvo', '#FFFFFFFF', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 0
	UNION ALL (SELECT 1, 1, descripcion, '#00000000', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, id FROM cxc_t_estatus_fac)
) dt;

INSERT INTO t_estatuses (estatus, para, descripcion, color, created_at, updated_at)
SELECT estatus, para, descripcion, color, created_at, updated_at
FROM estatuses_normalizados
GROUP BY prediction_id, estatus, para, descripcion, color, created_at, updated_at
ORDER BY prediction_id;

CREATE MATERIALIZED VIEW tipo_personas_normalizados AS
SELECT 
	row_number() OVER (ORDER BY dt.descripcion) AS prediction_id
	, dt.*
FROM (
	SELECT descripcion, estatus, CURRENT_TIMESTAMP created_at, CURRENT_TIMESTAMP updated_at
	FROM cxc_t_tipo_persona
) dt;

INSERT INTO t_tipo_personas (descripcion, estatus, created_at, updated_at)
SELECT descripcion, estatus, created_at, updated_at
FROM tipo_personas_normalizados;

UPDATE t_tipo_personas SET descripcion = REPLACE(descripcion, 'Juridicas', 'Jurídicas');

CREATE MATERIALIZED VIEW empresa_tipo_valors_normalizados AS
SELECT 
	row_number() OVER (ORDER BY dt.descripcion) AS prediction_id
	, dt.*
FROM (
	SELECT 'Desconocido' descripcion, 0 estatus, CURRENT_TIMESTAMP created_at, CURRENT_TIMESTAMP updated_at
	UNION ALL (SELECT DISTINCT TRIM(UPPER(tipo_valor)), 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
	FROM cxc_t_clientes_padre
	WHERE TRIM(UPPER(tipo_valor)) != '' AND TRIM(UPPER(tipo_valor)) != '0'
	ORDER BY 1)
) dt;

INSERT INTO t_empresa_tipo_valors(descripcion, estatus, created_at, updated_at)
SELECT descripcion, estatus, created_at, updated_at
FROM empresa_tipo_valors_normalizados;

CREATE MATERIALIZED VIEW empresa_sector_economicos_normalizados AS
SELECT 
	row_number() OVER (ORDER BY dt.descripcion) AS prediction_id
	, dt.*
FROM (
	SELECT 'Desconocido' descripcion, 0 estatus, CURRENT_TIMESTAMP created_at, CURRENT_TIMESTAMP updated_at
	UNION ALL (SELECT DISTINCT TRIM(UPPER(sector_economico)), 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
	FROM cxc_t_clientes_padre
	WHERE sector_economico != '' AND sector_economico != '0' AND sector_economico != '11' AND sector_economico != '123'
	ORDER BY 1)
) dt;

INSERT INTO t_empresa_sector_economicos(descripcion, estatus, created_at, updated_at)
SELECT descripcion, estatus, created_at, updated_at
FROM empresa_sector_economicos_normalizados;

CREATE MATERIALIZED VIEW tipo_emisions_normalizados AS
SELECT 
	row_number() OVER (ORDER BY dt.descripcion) AS prediction_id
	, dt.*
FROM (
	SELECT 'Desconocido' descripcion, 0 estatus, CURRENT_TIMESTAMP created_at, CURRENT_TIMESTAMP updated_at
	UNION ALL (SELECT descripcion, estatus, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
	from cxc_t_tipo_emision
	ORDER BY 1)
) dt;

INSERT INTO t_tipo_emisions (descripcion, estatus, created_at, updated_at)
SELECT descripcion, estatus, created_at, updated_at
FROM tipo_emisions_normalizados;

CREATE MATERIALIZED VIEW periodos_normalizados AS
SELECT 
	row_number() OVER (ORDER BY dt.prev_id) prediction_id
	, dt.*
FROM (
	SELECT 'Desconocido' descripcion, 0 estatus, CURRENT_TIMESTAMP created_at, CURRENT_TIMESTAMP updated_at, '0' rango_dias, 1 dia_tope, 1 mes_tope, 0 prev_id
	UNION ALL (select descripcion, estatus, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, rango_dias, dia_tope, mes_tope, idt_periodo
		from cxc_t_periodo
		ORDER BY 1)
) dt;

INSERT INTO t_periodos (descripcion, estatus, created_at, updated_at, rango_dias, dia_tope, mes_tope)
SELECT descripcion, estatus, created_at, updated_at, rango_dias, dia_tope, mes_tope
FROM periodos_normalizados;

CREATE MATERIALIZED VIEW recargos_normalizados AS
SELECT 
	row_number() OVER (ORDER BY dt.prev_id) prediction_id
	, dt.*
FROM (
	SELECT 'Desconocido' descripcion, 0 tasa, 0 estatus, CURRENT_TIMESTAMP created_at, CURRENT_TIMESTAMP updated_at, 0 prev_id
	UNION ALL (select descripcion, tasa, estatus, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, idt_recargo prev_id
	from cxc_t_recargo
	ORDER BY 1)
) dt;

INSERT INTO t_recargos (descripcion, tasa, estatus, created_at, updated_at, t_periodo_id)
SELECT descripcion, tasa, estatus, created_at, updated_at, 2
FROM recargos_normalizados;


CREATE MATERIALIZED VIEW empresas_normalizadas AS
SELECT
	s.prev_client_id, pp.* 
FROM (
	SELECT
		row_num AS prediction_id,
		rw.codigo,
		rw.rif,
		rw.dv,
		rw.razon_social,
		TRIM (REPLACE ( rw.direccion, 'Desconocida,', '' )) direccion,
		TRIM (REPLACE ( rw.fax, '0, ', '' )) fax,
		TRIM (REPLACE ( rw.web, '0, ', '' )) web,
		TRIM (REPLACE ( rw.telefono, '0, ', '' )) telefono,
		TRIM (REPLACE ( rw.email, 'desconocido@svm.com,', '' )) email,
		tipo_valor_id [ 1 ] tipo_valor_id,
		sector_economico_id [ 1 ] sector_economico_id,
		fecha_registro [ 1 ] fecha_registro,
		rw.prev_ids 
	FROM (
		SELECT 
			ROW_NUMBER() OVER ( ORDER BY ens.razon_social ) AS row_num,
			ens.razon_social,
			string_agg (DISTINCT ens.codigo, '|' ) AS codigo,
			string_agg (DISTINCT ens.rif, '|' ) AS rif,
			string_agg (DISTINCT CAST ( ens.dv AS VARCHAR ), '|' ) AS dv,
			string_agg (DISTINCT CAST ( ens.prev_id AS VARCHAR ), '|' ) AS prev_ids,
			string_agg (DISTINCT ens.resolucion, '|' ) AS resoluciones,
			string_agg (DISTINCT ens.direccion, ', ' ) direccion,
			string_agg (DISTINCT ens.fax, ', ' ) AS fax,
			string_agg (DISTINCT ens.web, ', ' ) AS web,
			string_agg (DISTINCT ens.telefono, ', ' ) AS telefono,
			string_agg (DISTINCT ens.email, ', ' ) AS email,
			ARRAY_AGG (DISTINCT ens.tipo_valor_id ) AS tipo_valor_id,
			ARRAY_AGG (DISTINCT ens.sector_economico_id ) AS sector_economico_id,
			ARRAY_AGG (DISTINCT ens.fecha_registro ) AS fecha_registro 			
		FROM (
			SELECT
				dt.codigo,
				dt.rif,
				CASE
					WHEN dt.count_res = 1 THEN CAST(dt.res[1] as integer)
					ELSE 0
				END dv,
				CASE
					WHEN UPPER ( dt.apellido ) ~ '(D[.]*V[.]*)' THEN UPPER ( dt.nombre )
					ELSE UPPER( dt.nombre ) || ' ' || UPPER ( dt.apellido )
				END razon_social,
				UPPER (TRIM ( dt.sector_economico )) sector_economico,
				UPPER (TRIM ( dt.tipo_valor )) tipo_valor,
				COALESCE ( dt.telefono, '0' ) telefono,
				COALESCE ( dt.email, 'desconocido@svm.com' ) email,
				COALESCE ( dt.direccion_empresa, 'Desconocida' ) direccion,
				COALESCE ( dt.fax, NULL ) fax,
				COALESCE ( dt.web, NULL ) web,
				COALESCE ( tetv.ID, 1 ) tipo_valor_id,
				COALESCE ( tese.ID, 1 ) sector_economico_id,
				dt.prev_id,
				dt.resolucion,
				dt.fecha_registro
			FROM (
				SELECT
					ctcs.codigo,
					CASE WHEN TRIM
							( ctcs.cedula ) = '' 
							OR TRIM ( ctcs.cedula ) = '0'
							OR TRIM ( ctcs.cedula ) = '000' THEN
								'NF'||ctcs.idt_clientes ELSE TRIM ( ctcs.cedula ) 
							END rif,
					CASE WHEN TRIM
							( ctcs.nombre ) = '' 
							OR TRIM ( ctcs.nombre ) = '0' THEN
								'' ELSE TRIM ( ctcs.nombre ) 
							END nombre,
					CASE WHEN TRIM ( ctcs.apellido ) = '' 
							OR TRIM ( ctcs.apellido ) = '0' THEN ''
						ELSE TRIM ( ctcs.apellido ) 
						END apellido,
					CASE WHEN TRIM ( ctcs.telefono ) = '' 
						OR TRIM ( ctcs.telefono ) = '0' THEN
						'0' ELSE TRIM ( ctcs.telefono ) 
						END telefono,
					CASE WHEN TRIM ( ctcs.email ) = '' 
						OR TRIM ( ctcs.email ) = '0' THEN
						'desconocido@svm.com' ELSE TRIM ( ctcs.email ) 
						END email,
					CASE WHEN TRIM ( ctcs.direccion_empresa ) = '' 
						OR TRIM ( ctcs.direccion_empresa ) = '0' THEN
						'Desconocida' ELSE TRIM ( ctcs.direccion_empresa ) 
						END direccion_empresa,
					CASE WHEN TRIM ( ctcp.sector_economico ) = '' 
						OR TRIM ( ctcp.sector_economico ) = '0' THEN
						NULL ELSE TRIM ( ctcp.sector_economico ) 
						END sector_economico,
					CASE WHEN TRIM ( ctcp.tipo_valor ) = '' 
						OR TRIM ( ctcp.tipo_valor ) = '0' THEN
						NULL ELSE TRIM ( ctcp.tipo_valor ) 
						END tipo_valor,
					ctcs.fax AS fax,
					ctcs.web AS web,
					ctcs.fecha_registro AS fecha_registro,
					ctcs.idt_clientes AS prev_id
					, ctcs.resolucion
					, NOT ( ctcs.idt_tipo_cliente IN ( 1, 2, 3, 13, 16, 21 ) ) es_empresa
					, res
					, array_length(res, 1) count_res
				FROM cxc_t_clientes ctcs
				LEFT JOIN cxc_t_clientes_padre ctcp ON ctcp.idt_clientes_padre = ctcs.idt_cliente_padre 
				LEFT JOIN regexp_matches(ctcs.apellido, '([0-9]+)') res ON 1 = 1
			) dt			
			LEFT JOIN t_empresa_sector_economicos tese ON UPPER ( dt.sector_economico ) = tese.descripcion
			LEFT JOIN t_empresa_tipo_valors tetv ON UPPER ( dt.tipo_valor ) = tetv.descripcion 
		WHERE
			dt.es_empresa = TRUE 
		) ens 
		GROUP BY 2 
		) rw 
	) pp,
	UNNEST (string_to_array( pp.prev_ids, '|' )) s ( prev_client_id );

INSERT INTO t_empresas (rif, dv, razon_social, direccion_empresa, fax, web, telefono, email, t_empresa_tipo_valor_id, t_empresa_sector_economico_id)
SELECT rif, dv, razon_social, direccion, fax, web, telefono, email, tipo_valor_id, sector_economico_id
FROM empresas_normalizadas
GROUP BY prediction_id, rif, dv, razon_social, direccion, fax, web, telefono, email, tipo_valor_id, sector_economico_id
ORDER BY prediction_id;

CREATE MATERIALIZED VIEW personas_normalizados AS
SELECT pp.*, s.prev_client_id
FROM (
SELECT
	rww.prediction_id,
	rww.codigo,
	rww.cedula,
	rww.nombre,
	rww.apellido,	
	cast(rww.empresa as BIGINT) t_empresa_id,
	rww.cargo,
	rww.telefono,
	rww.email,
	rww.direccion,
	rww.fecha_registro,
	rww.prev_ids
FROM (
	SELECT 
		dtt.prediction_id,
		dtt.prev_ids,
		dtt.nombre,
		dtt.codigo,
		dtt.cedula,
		dtt.apellido,		
		null empresa,
		dtt.cargo,
		trim(replace(dtt.telefono, '0,', '')) telefono,
		trim(replace(dtt.email, 'desconocido@svm.com,', '')) email,
		trim(replace(dtt.direccion, 'Desconocida,', '')) direccion,
		fecha_registro [ 1 ] fecha_registro
	FROM (
SELECT
	row_number() OVER (ORDER BY pns.nombre, pns.apellido) AS prediction_id
	, pns.nombre	
	, pns.apellido
	, string_agg(distinct pns.codigo, ', ') as codigo
	, string_agg(distinct pns.cedula, ', ') as cedula
	, string_agg(distinct pns.cargo, ', ') as cargo
	, string_agg(distinct pns.telefono, ', ') as telefono
	, string_agg(distinct pns.email, ', ') as email
	, string_agg(distinct pns.direccion, ', ') as direccion
	, ARRAY_AGG(distinct pns.fecha_registro) as fecha_registro
	, string_agg(distinct CAST(pns.prev_id as VARCHAR), '|') as prev_ids
FROM (
SELECT
	 CASE
		WHEN rw.apellido IS NOT NULL THEN rw.nombre
		WHEN rw.count_res = 3 AND lower(trim(rw.res[1])) = 'de' THEN rw.res[3]
		WHEN rw.count_res = 1 
			OR rw.count_res = 2 
			OR rw.count_res = 3 
			OR (rw.count_res = 4 AND lower(trim(rw.res[2])) = 'de' AND lower(trim(rw.res[3])) = 'la')
			OR (rw.count_res = 4 AND lower(trim(rw.res[2])) = 'del')
			OR (rw.count_res = 5 AND lower(trim(rw.res[2])) = 'de')
		THEN rw.res[1]
		WHEN rw.count_res = 4 AND lower(trim(rw.res[1])) = 'de' THEN rw.res[4]
		WHEN rw.count_res = 4 OR rw.count_res = 5 THEN rw.res[1] || ' ' || rw.res[2]
		WHEN rw.count_res = 6 AND lower(trim(rw.res[1])) = 'de' AND lower(trim(rw.res[2])) = 'la' THEN rw.res[6]
		WHEN rw.count_res = 6 AND lower(trim(rw.res[1])) = 'de' THEN rw.res[6] || ' ' || rw.res[5]
		WHEN rw.count_res = 6 OR rw.count_res = 7 THEN rw.res[1] || ' ' || rw.res[2] || ' ' || rw.res[3]
		WHEN rw.count_res = 8 THEN rw.res[1] || ' ' || rw.res[2] || ' ' || rw.res[3] || ' ' || rw.res[4]
		ELSE null 
	END nombre
, CASE 
		WHEN rw.apellido IS NOT NULL THEN rw.apellido
		WHEN rw.count_res = 1 THEN ''
		WHEN rw.count_res = 2 THEN rw.res[2] 
		WHEN rw.count_res = 3 AND lower(trim(rw.res[1])) = 'de' THEN rw.res[1] || ' ' || rw.res[2]
		WHEN rw.count_res = 3 THEN rw.res[2] || ' ' || rw.res[3]
		WHEN rw.count_res = 4 AND lower(trim(rw.res[1])) = 'de' THEN rw.res[3] || ' ' || rw.res[1] || ' ' || rw.res[2]
		WHEN rw.count_res = 4 AND (
				(lower(trim(rw.res[2])) = 'de' AND lower(trim(rw.res[3])) = 'la') 
			OR lower(trim(rw.res[2])) = 'del') THEN rw.res[2] || ' ' || rw.res[3] || ' ' || rw.res[4]
		WHEN rw.count_res = 4 THEN rw.res[3] || ' ' || rw.res[4]
		WHEN rw.count_res = 5 AND lower(trim(res[2])) = 'de' THEN rw.res[2] || ' ' || rw.res[3] || ' ' || rw.res[4] || ' ' || rw.res[5]
		WHEN rw.count_res = 5 THEN rw.res[3] || ' ' || rw.res[4] || rw.res[5]
		WHEN rw.count_res = 6 AND lower(trim(rw.res[1])) = 'de' AND lower(trim(rw.res[2])) = 'la' THEN rw.res[4]|| ' ' || rw.res[5] || ' ' || rw.res[1] || ' ' || rw.res[2] || ' ' || rw.res[3]
		WHEN rw.count_res = 6 AND lower(trim(rw.res[1])) = 'de' THEN rw.res[4] || ' ' || rw.res[3] || ' ' || rw.res[1] || ' ' || rw.res[2]
		WHEN rw.count_res = 6 THEN rw.res[4] || ' ' || rw.res[5] || ' ' || rw.res[6]
	  WHEN rw.count_res = 7 THEN rw.res[4] || ' ' || rw.res[5] || ' ' || rw.res[6] || ' ' || rw.res[7]
		WHEN rw.count_res = 8 THEN rw.res[5] || ' ' || rw.res[6] || ' ' || rw.res[7] || ' ' || rw.res[8]
		ELSE null 
	END apellido
, rw.cedula
, rw.codigo
, rw.cargo
, rw.telefono
, rw.email
, rw.direccion
, rw.fecha_registro
, rw.prev_id
FROM (
	SELECT
		dt.codigo
		, dt.cedula
		, dt.nombre
		, REGEXP_REPLACE(dt.apellido, '\s*-.+', '') as apellido
		, UPPER(TRIM(dt.cargo)) cargo
		, COALESCE(dt.telefono, '0') telefono
		, COALESCE(dt.email, 'desconocido@svm.com') email
		, COALESCE(dt.direccion_empresa, 'Desconocida') direccion
		, dt.fecha_registro
		, res
		, array_length(res, 1) count_res
		, dt.prev_id
	FROM (
		SELECT 
			ctcs.codigo
		, CASE 
				WHEN TRIM(ctcs.cedula) = '' OR TRIM(ctcs.cedula) = '0' THEN 'NF'||ctcs.idt_clientes
				ELSE TRIM(ctcs.cedula) 
			END cedula
		, CASE 
				WHEN TRIM(ctcs.nombre) = '' OR TRIM(ctcs.nombre) = '0' THEN NULL 
				ELSE UPPER(TRIM(REPLACE(ctcs.nombre, '-', ' '))) 
			END nombre		
		, CASE 
				WHEN TRIM(ctcs.apellido) = '' OR TRIM(ctcs.apellido) = '0' THEN NULL 
				ELSE UPPER(TRIM(ctcs.apellido)) 
			END apellido
		, CASE 
				WHEN TRIM(ctcs.telefono) = '' OR TRIM(ctcs.telefono) = '0' THEN NULL 
				ELSE TRIM(ctcs.telefono) 
			END telefono
		, CASE 
				WHEN TRIM(ctcs.email) = '' OR TRIM(ctcs.email) = '0' THEN NULL 
				ELSE TRIM(ctcs.email) 
			END email
		, CASE 
				WHEN TRIM(ctcs.direccion_empresa) = '' OR TRIM(ctcs.direccion_empresa) = '0' THEN NULL 
				ELSE TRIM(ctcs.direccion_empresa) 
			END direccion_empresa
		, CASE 
				WHEN array_length(crg, 1) = 2 THEN crg[2] 
				WHEN array_length(crg, 1) = 3 THEN crg[2] || '' || crg[3] 
				WHEN array_length(crg, 1) = 4 THEN crg[2] || '' || crg[3]  || '' || crg[4] 
				WHEN TRIM(ctcs.cargo) = '' OR TRIM(ctcs.cargo) = '0' THEN NULL 
				ELSE TRIM(ctcs.cargo)
			END cargo
		, ctcs.fecha_registro as fecha_registro
		, ctcs.idt_clientes as prev_id
		, NOT ( ctcs.idt_tipo_cliente IN ( 1, 2, 3, 13, 16, 21 ) ) es_empresa 
		FROM cxc_t_clientes ctcs
		LEFT JOIN regexp_split_to_array(trim(ctcs.apellido), '(?:[-]+)') crg ON 1 = 1
	) dt
	LEFT JOIN regexp_split_to_array(trim(dt.nombre, ' .'), '(?:[\s,\.]+)') res ON 1 = 1
	WHERE
		dt.es_empresa = FALSE 
) rw
		) pns
GROUP BY 2, 3, pns.fecha_registro
ORDER BY pns.fecha_registro asc
) dtt
) rww
) pp
, UNNEST (string_to_array( pp.prev_ids, '|' )) s ( prev_client_id );

INSERT INTO t_personas (cedula, nombre, apellido, t_empresa_id, cargo, telefono, email, direccion)
SELECT cedula, nombre, apellido, t_empresa_id, cargo, telefono, email, direccion
FROM personas_normalizados
GROUP BY prediction_id, cedula, nombre, apellido, t_empresa_id, cargo, telefono, email, direccion
ORDER BY prediction_id;

CREATE MATERIALIZED VIEW clientes_normalizados AS
SELECT 
	pp.*
	, CAST(s.prev_client_id as INT) prev_client_id
FROM (
	SELECT 
		row_number() OVER (ORDER BY dt.t_estatus_id) AS prediction_id
		, dt.t_estatus_id
		, dt.created_at
		, dt.updated_at
		, dt."id" persona_id
		, dt.codigo
		, dt."type" persona_type
		, dt.client_ids
	FROM (
		SELECT 2 "t_estatus_id"
		, rw.fecha_registro created_at
		, rw.fecha_registro updated_at
		, rw.prediction_id "id"
		, rw.codigo
		, 'TEmpresa' "type"
		, rw.prev_ids "client_ids"
		FROM empresas_normalizadas rw
		GROUP BY rw.prediction_id, rw.codigo, rw.fecha_registro, rw.prev_ids
		UNION ALL (
			SELECT 2 "t_estatus_id"
			, rw.fecha_registro created_at
			, rw.fecha_registro updated_at
			, rw.prediction_id "id"
			, rw.codigo
			, 'TPersona' "type"
			, rw.prev_ids "client_ids"
			FROM personas_normalizados rw
			GROUP BY rw.prediction_id, rw.codigo, rw.fecha_registro, rw.prev_ids
		)
	)	dt
) pp
, UNNEST (string_to_array( pp.client_ids, '|' )) s ( prev_client_id );

INSERT INTO t_clientes (codigo, t_estatus_id, created_at, updated_at, persona_id, persona_type)
SELECT codigo, t_estatus_id, created_at, updated_at, persona_id, persona_type
FROM clientes_normalizados
GROUP BY prediction_id, codigo, t_estatus_id, created_at, updated_at, persona_id, persona_type
ORDER BY prediction_id;

CREATE MATERIALIZED VIEW resoluciones_normalizadas AS
SELECT
	ctc.*
FROM (	
	SELECT 
			cli.resolucion
		, cli.prediction_id
		, ('' || cli.num_licencias [ 1 ]) num_licencia
		, cli.tipo_client_ids [ 1 ] t_tipo_cliente_id
		, cli.originales
		, CONCAT('CxC-', cli.prediction_id ) codigo
		, CONCAT('Resolución de migración ', cli.originales) descripcion
		, COALESCE(cli.fecha_resolucion [ 1 ], '1971-01-01') created_at
		, COALESCE(cli.fecha_resolucion [ 1 ], '1971-01-01') updated_at	
		, 2 t_estatus_id
		, s.prev_client_id
		, c.client_id t_cliente_id
	FROM (
		SELECT
			CASE WHEN cxccli.resolucion = '0' OR cxccli.resolucion = 'SMV N' THEN
					cxccli.resolucion || ' > ' || UPPER (TRIM ( cxccli.nombre )) || ' ' || UPPER (
					TRIM ( cxccli.apellido )) 
				ELSE TRIM ( cxccli.resolucion ) 
			END resolucion,
			ROW_NUMBER () OVER ( ORDER BY 1 ) AS prediction_id,
			ARRAY_AGG ( DISTINCT cxccli.idt_clientes ) prev_client_ids,
			ARRAY_AGG ( DISTINCT cns.prediction_id ) client_ids,
			ARRAY_AGG ( DISTINCT cxccli.num_licencia ) num_licencias,
			ARRAY_AGG ( DISTINCT cxccli.fecha_resolucion ) fecha_resolucion,
			ARRAY_AGG ( DISTINCT ttcs.ID ) tipo_client_ids,
			STRING_AGG ( DISTINCT TRIM ( cxccli.resolucion ), ' | ') originales 
		FROM
			cxc_t_clientes cxccli
			LEFT JOIN clientes_normalizados cns ON cxccli.idt_clientes = cns.prev_client_id
			LEFT JOIN cxc_t_tipo_cliente cttc ON cxccli.idt_tipo_cliente = cttc.idt_tipo_cliente
			LEFT JOIN t_tipo_clientes ttcs ON TRIM (
			UPPER ( cttc.descripcion )) = ttcs.descripcion 
		GROUP BY 1 
		) cli,
		UNNEST ( cli.prev_client_ids ) s ( prev_client_id ),
		UNNEST ( cli.client_ids ) c (client_id )
) ctc;

INSERT INTO t_resolucions (resolucion, codigo, descripcion, created_at, updated_at, t_cliente_id, t_estatus_id, t_tipo_cliente_id, num_licencia)
SELECT 
  dt.resolucion
, dt.codigo
, dt.descripcion
, dt.created_at
, dt.updated_at
, dt.t_cliente_ids [1]
, dt.t_estatus_id
, dt.t_tipo_cliente_id
, dt.num_licencia
FROM (
	SELECT resolucion, codigo, descripcion, created_at, updated_at, array_agg(t_cliente_id) t_cliente_ids, t_estatus_id, t_tipo_cliente_id, num_licencia
	FROM resoluciones_normalizadas
	GROUP by prediction_id, resolucion, codigo, descripcion, created_at, updated_at, t_estatus_id, t_tipo_cliente_id, num_licencia
	ORDER BY prediction_id
) dt;

UPDATE t_clientes 
	SET prospecto_at = CURRENT_TIMESTAMP
FROM t_resolucions trs
WHERE trs.t_cliente_id = t_clientes."id";

--CREATE MATERIALIZED VIEW rols_normalizados AS
--SELECT url direccion_url, li_class, i_class, u_class, trim(nombre) nombre, descripcion, peso, estatus, icon_class, CURRENT_TIMESTAMP created_at, CURRENT_TIMESTAMP updated_at, idt_rol prev_id
--FROM cxc_t_rol;

--INSERT INTO t_rols (direccion_url, li_class, i_class, u_class, nombre, descripcion, peso, estatus, icon_class, created_at, updated_at)
--SELECT direccion_url, li_class, i_class, u_class, nombre, descripcion, peso, estatus, icon_class, created_at, updated_at
--FROM rols_normalizados;

--CREATE MATERIALIZED VIEW rols_desc_normalizados AS
--SELECT  trs.id t_rol_id, ctrd.id_objeto, TRIM(ctrd.nombre) nombre, ctrd.pagina, ctrd.estatus, CURRENT_TIMESTAMP created_at, CURRENT_TIMESTAMP updated_at, 'Por definir' descripcion
--FROM cxc_t_rol_desc ctrd
--JOIN rols_normalizados rns ON ctrd.idt_rol = rns.prev_id
--JOIN t_rols trs ON rns.nombre = trs.nombre;

--INSERT INTO t_rol_descs (t_rol_id, id_objeto, nombre, pagina, estatus, created_at, updated_at, descripcion)
--SELECT t_rol_id, id_objeto, nombre, pagina, estatus, created_at, updated_at, descripcion
--FROM rols_desc_normalizados;

CREATE MATERIALIZED VIEW usuarios_normalizados AS
SELECT 
	row_number() OVER (ORDER BY 1, 2) AS prediction_id
	, ctus.nombre nombre
	, ctus.apellido apellido
	, 1 estatus
	, null avatar
	, CURRENT_TIMESTAMP created_at
	, CURRENT_TIMESTAMP updated_at
	, ctus.email email
	, '$2a$11$2QPwHf1tjsRuGKQpk.eOxu4LyJbMwrxwHwnooWhU6a1IptooFo4O6' encrypted_password
	, null reset_password_token
	, null reset_password_sent_at
	, null remember_created_at
	, 0 sign_in_count
	, null current_sign_in_at
	, null last_sign_in_at
	, null current_sign_in_ip
	, null last_sign_in_ip
	, null picture
	, 'SuperAdmin' "role"
	, ctus.idt_usuario prev_id
	, ctus.idt_rol prev_rol_id
FROM cxc_t_usuario ctus;

INSERT INTO users (nombre, apellido, estatus, avatar, created_at, updated_at, email, encrypted_password, picture, "role")
SELECT nombre, apellido, estatus, avatar, created_at, updated_at, email, encrypted_password, picture, "role"
FROM usuarios_normalizados
GROUP by prediction_id, nombre, apellido, estatus, avatar, created_at, updated_at, email, encrypted_password, picture, "role"
ORDER BY prediction_id;

INSERT INTO t_rol_usuarios(user_id, t_rol_id, created_at, updated_at) VALUES (1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

--INSERT INTO t_users_rols (t_rol_id, user_id)
--SELECT  trs.id t_rol_id, us.id user_id
--FROM cxc_t_usuario_x_rol ctuxr
--JOIN rols_normalizados rns ON ctuxr.idt_rol = rns.prev_id
--JOIN t_rols trs ON trs.nombre = rns.nombre
--JOIN usuarios_normalizados uns ON ctuxr.idt_usuario = uns.prev_id
--JOIN users us ON uns.email = us.email;

CREATE MATERIALIZED VIEW leyendas_normalizadas AS
SELECT 0 anio, 'Desconocido' descripcion, 0 estatus, CURRENT_TIMESTAMP created_at, CURRENT_TIMESTAMP updated_at, 0 prev_id
UNION ALL (SELECT anio, TRIM(detalle) descripcion, estatus, CURRENT_TIMESTAMP created_at, CURRENT_TIMESTAMP updated_at, idt_leyenda prev_id FROM cxc_t_leyenda);

INSERT INTO t_leyendas (anio, descripcion, estatus, created_at, updated_at)
SELECT anio, descripcion, estatus, created_at, updated_at
FROM leyendas_normalizadas;

CREATE MATERIALIZED VIEW facturas_normalizadas AS
SELECT 
	row_number() OVER (ORDER BY dt.prev_id, dt.fecha_notificacion, dt.fecha_vencimiento, dt.recargo, dt.recargo_desc, dt.itbms, dt.cantidad_total, dt.importe_total, dt.total_factura, dt.pendiente_fact, dt.pendiente_ts, dt.tipo, dt.justificacion, dt.fecha_erroneo, dt.next_fecha_recargo, dt.monto_emision, dt.created_at, dt.updated_at, dt.t_resolucion_id, dt.t_periodo_id, dt.t_estatus_id, dt.t_leyenda_id, dt.user_id, dt.automatica) AS prediction_id
	, dt.fecha_notificacion
	, dt.fecha_vencimiento
	, dt.recargo
	, dt.recargo_desc
	, dt.itbms
	, dt.cantidad_total
	, dt.importe_total
	, dt.total_factura
	, dt.pendiente_fact
	, dt.pendiente_ts
	, dt.tipo
	, dt.justificacion
	, dt.fecha_erroneo
	, dt.next_fecha_recargo
	, dt.monto_emision
	, dt.created_at
	, dt.updated_at
	, dt.t_resolucion_id
	, dt.t_periodo_id
	, COALESCE(dt.t_estatus_id, 2) t_estatus_id
	, dt.t_leyenda_id
	, dt.user_id
	, dt.automatica
	, dt.prev_id
FROM ( SELECT
	CURRENT_TIMESTAMP fecha_notificacion
	, ctfs.fecha_vencimiento fecha_vencimiento
	, ctfs.recargo recargo
	, UPPER(TRIM(ctfs.recargo_desc)) recargo_desc
	, ctfs.itbms itbms
	, ctfs.cantidad_total cantidad_total
	, ctfs.importe_total importe_total
	, ctfs.total_factura total_factura
	, ctfs.pendiente_fact pendiente_fact
	, ctfs.pendiente_ts pendiente_ts
	, ctfs.tipo tipo
	, ctfs.justificacion justificacion
	, ctfs.fecha_erroneo fecha_erroneo
	, COALESCE(ctfs.next_fecha_recargo, '1971-01-01') next_fecha_recargo
	, 0 monto_emision
	, COALESCE(ctfs.fecha_factura, '1971-01-01') created_at
	, COALESCE(ctfs.fecha_factura, '1971-01-01') updated_at
	, resoluciones.prediction_id t_resolucion_id
	, pns.prediction_id t_periodo_id
	, ens.prediction_id t_estatus_id
	, 1 t_leyenda_id
	, COALESCE(uns.prediction_id, 1) user_id
	, false automatica
	, ctfs.idt_facturas prev_id
FROM cxc_t_facturas ctfs
LEFT JOIN resoluciones_normalizadas resoluciones ON ctfs.idt_clientes = resoluciones.prev_client_id
LEFT JOIN periodos_normalizados pns on ctfs.idt_periodo = pns.prev_id
LEFT JOIN estatuses_normalizados ens ON ctfs.estatus = ens.prev_id AND ens.prev_id != 0
LEFT JOIN usuarios_normalizados uns ON ctfs.id_usuario = uns.prev_id 
)	dt; 

INSERT INTO t_facturas (fecha_notificacion, fecha_vencimiento, recargo, recargo_desc, itbms, cantidad_total, importe_total, total_factura, pendiente_fact, pendiente_ts, tipo, justificacion, fecha_erroneo, next_fecha_recargo, monto_emision, created_at, updated_at, t_resolucion_id, t_periodo_id, t_estatus_id, t_leyenda_id, user_id, automatica)
SELECT fecha_notificacion, fecha_vencimiento, recargo, recargo_desc, itbms, cantidad_total, importe_total, total_factura, pendiente_fact, pendiente_ts, tipo, justificacion, fecha_erroneo, next_fecha_recargo, monto_emision, created_at, updated_at, t_resolucion_id, t_periodo_id, t_estatus_id, t_leyenda_id, user_id, automatica
FROM facturas_normalizadas
GROUP by prediction_id, fecha_notificacion, fecha_vencimiento, recargo, recargo_desc, itbms, cantidad_total, importe_total, total_factura, pendiente_fact, pendiente_ts, tipo, justificacion, fecha_erroneo, next_fecha_recargo, monto_emision, created_at, updated_at, t_resolucion_id, t_periodo_id, t_estatus_id, t_leyenda_id, user_id, automatica
ORDER BY prediction_id;

CREATE MATERIALIZED VIEW tarifa_servicios_normalizados AS
SELECT 
	row_number() OVER (ORDER BY dt.prev_id, dt.codigo, dt.descripcion, dt.nombre, dt.clase, dt.precio, dt.estatus, dt.created_at, dt.updated_at) AS prediction_id
	, dt.codigo, dt.descripcion, dt.nombre, dt.clase, dt.precio, dt.estatus, dt.created_at, dt.updated_at, dt.prev_id
FROM (SELECT '0000' codigo, 'Desconocida' descripcion, 'Desconocido' nombre, 'Desconocido' clase, 0 precio, 0 estatus, CURRENT_TIMESTAMP created_at, CURRENT_TIMESTAMP updated_at, 0 prev_id
UNION ALL (SELECT ctts.codigo codigo, TRIM(ctts.descripcion) descripcion, TRIM(ctts.nombre) nombre, ctts.clase clase, ctts.precio precio, ctts.estatus estatus, CURRENT_TIMESTAMP created_at, CURRENT_TIMESTAMP updated_at, ctts.idt_tarifa_servicios prev_id FROM cxc_t_tarifa_servicios ctts)) dt;

INSERT INTO t_tarifa_servicios (codigo, descripcion, nombre, clase, precio, estatus, created_at, updated_at)
SELECT codigo, descripcion, nombre, clase, precio, estatus, created_at, updated_at
FROM tarifa_servicios_normalizados
GROUP by prediction_id, codigo, descripcion, nombre, clase, precio, estatus, created_at, updated_at
ORDER BY prediction_id;

CREATE MATERIALIZED VIEW factura_detalle_normalizado AS
SELECT ctfd.cantidad, ctfd.cuenta_desc, ctfd.precio_unitario, tfs.id t_factura_id, tts.id t_tarifa_servicio_id, CURRENT_TIMESTAMP created_at, CURRENT_TIMESTAMP updated_at, ctfd.idt_factura_detalle prev_id
FROM cxc_t_factura_detalle ctfd
JOIN facturas_normalizadas fns ON ctfd.idt_factura = fns.prev_id
JOIN t_facturas tfs ON fns.prediction_id = tfs.id
JOIN tarifa_servicios_normalizados tsns ON ctfd.idt_tarifa_servicios = tsns.prev_id
JOIN t_tarifa_servicios tts ON tsns.prediction_id = tts.id;

INSERT INTO t_factura_detalles (cantidad, cuenta_desc, precio_unitario, created_at, updated_at, t_factura_id, t_tarifa_servicio_id)
SELECT cantidad, cuenta_desc, precio_unitario, created_at, updated_at, t_factura_id, t_tarifa_servicio_id
FROM factura_detalle_normalizado;

UPDATE t_facturas
SET monto_emision = dt.monto
FROM (
	SELECT tfds.t_factura_id, SUM(COALESCE(tfds.cantidad, 0) * COALESCE(tfds.precio_unitario, 0)) monto
	FROM t_factura_detalles tfds
	GROUP BY tfds.t_factura_id) dt
WHERE dt.t_factura_id = t_facturas.id;

CREATE MATERIALIZED VIEW metodos_pago_normalizado AS
SELECT 
	row_number() OVER (ORDER BY dt.metodo_pago) AS prediction_id
	, dt.metodo_pago forma_pago
	, 'Deribado de la migración de recibos' descripcion
	, CAST(null as numeric) minimo
	, CAST(null as numeric) maximo
	, 1 estatus
	, CURRENT_TIMESTAMP created_at
  , CURRENT_TIMESTAMP updated_at
	
FROM (
	SELECT DISTINCT metodo_pago
	FROM cxc_t_recibos
	ORDER BY 1
) dt;

INSERT INTO t_metodo_pagos (forma_pago, descripcion, minimo, maximo, estatus, created_at, updated_at)
SELECT forma_pago, descripcion, minimo, maximo, estatus, created_at, updated_at
FROM metodos_pago_normalizado
GROUP by prediction_id, forma_pago, descripcion, minimo, maximo, estatus, created_at, updated_at
ORDER BY prediction_id;


CREATE MATERIALIZED VIEW recibos_normalizado AS
SELECT  
  	ctre.fecha_pago
  , ctre.num_cheque
  , ctre.pago_recibido
  , ctre.monto_acreditado
  , ctre.cuenta_deposito
  , ctre.pago_pendiente
  , ctre.estatus
  , ctre.justificacion
  , ctre.fecha_erroneo
  , COALESCE(ctre.fecha_registro, '1971-01-01') created_at
	, COALESCE(ctre.fecha_registro, '1971-01-01') updated_at
  , fns.prediction_id t_factura_id
  , cns.prediction_id t_cliente_id
  , pns.prediction_id t_periodo_id
	, mpns.prediction_id t_metodo_pago_id
	, 1 user_id
	, CAST(null as numeric) recargo_x_pagar
	, CAST(null as numeric) servicios_x_pagar
FROM cxc_t_recibos ctre
LEFT JOIN facturas_normalizadas fns ON ctre.idt_facturas = fns.prev_id
JOIN clientes_normalizados cns ON ctre.idt_clientes = cns.prev_client_id
JOIN periodos_normalizados pns ON ctre.idt_periodo = pns.prev_id
JOIN metodos_pago_normalizado mpns ON ctre.metodo_pago = mpns.forma_pago;

INSERT INTO t_recibos (fecha_pago, num_cheque, pago_recibido, monto_acreditado, cuenta_deposito, pago_pendiente, estatus, justificacion, fecha_erroneo, created_at, updated_at, t_factura_id, t_cliente_id, t_periodo_id, t_metodo_pago_id, user_id, recargo_x_pagar, servicios_x_pagar)
SELECT fecha_pago, num_cheque, pago_recibido, monto_acreditado, cuenta_deposito, pago_pendiente, estatus, justificacion, fecha_erroneo, created_at, updated_at, t_factura_id, t_cliente_id, t_periodo_id, t_metodo_pago_id, user_id, recargo_x_pagar, servicios_x_pagar
FROM recibos_normalizado;

CREATE MATERIALIZED VIEW presupuesto_normalizados AS
SELECT
	row_number() OVER (ORDER BY ctp.idt_presupuesto) AS prediction_id
	, ctp.idt_presupuesto prev_id
	, ctp.codigo
	, ctp.descripcion
	, ctp.estatus
	, CURRENT_TIMESTAMP created_at
	, CURRENT_TIMESTAMP updated_at
FROM cxc_t_presupuesto ctp;

INSERT INTO t_presupuestos (codigo, descripcion, estatus, created_at, updated_at)
SELECT codigo, descripcion, estatus, created_at, updated_at
FROM presupuesto_normalizados
GROUP BY prediction_id, codigo, descripcion, estatus, created_at, updated_at
ORDER BY prediction_id;

CREATE MATERIALIZED VIEW tarifa_servicios_group_normalizadas AS
SELECT
	row_number() OVER (ORDER BY cttsg.idt_tarifa_servicios_group) AS prediction_id
	, cttsg.idt_tarifa_servicios_group prev_id
	, pns.prediction_id t_presupuesto_id
	, cttsg.nombre
	, cttsg.estatus
	, CURRENT_TIMESTAMP created_at
	, CURRENT_TIMESTAMP updated_at
FROM cxc_t_tarifa_servicios_group cttsg
JOIN presupuesto_normalizados pns ON cttsg.idt_presupuesto = pns.prev_id;

INSERT INTO t_tarifa_servicio_groups (nombre, estatus, created_at, updated_at, t_presupuesto_id)
SELECT nombre, estatus, created_at, updated_at, t_presupuesto_id
FROM tarifa_servicios_group_normalizadas
GROUP BY prediction_id, nombre, estatus, created_at, updated_at, t_presupuesto_id
ORDER BY prediction_id;

CREATE MATERIALIZED VIEW cuentas_financieras_normalizadas AS
SELECT
 row_number() OVER (ORDER BY ctcf.idt_cuenta_financiera) AS prediction_id
 , ctcf.idt_cuenta_financiera prev_id
 , tsgns.prediction_id t_tarifa_servicio_group_id
 , pns.prediction_id t_presupuesto_id
 , ctcf.codigo_presupuesto
 , ctcf.codigo_financiero
 , ctcf.descripcion_financiera
 , ctcf.descripcion_presupuestaria
 , CURRENT_TIMESTAMP created_at
 , CURRENT_TIMESTAMP updated_at
FROM cxc_t_cuenta_financiera ctcf
JOIN tarifa_servicios_group_normalizadas tsgns ON ctcf.idt_tarifa_servicios_group = tsgns.prev_id
JOIN presupuesto_normalizados pns ON ctcf.idt_presupuesto = pns.prev_id;

INSERT INTO t_cuenta_financieras (codigo_presupuesto, codigo_financiero, descripcion_financiera, descripcion_presupuestaria, created_at, updated_at, t_tarifa_servicio_group_id, t_presupuesto_id)
SELECT codigo_presupuesto, codigo_financiero, descripcion_financiera, descripcion_presupuestaria, created_at, updated_at, t_tarifa_servicio_group_id, t_presupuesto_id
FROM cuentas_financieras_normalizadas
GROUP BY prediction_id, codigo_presupuesto, codigo_financiero, descripcion_financiera, descripcion_presupuestaria, created_at, updated_at, t_tarifa_servicio_group_id, t_presupuesto_id
ORDER BY prediction_id;

-- Ultimo registro
INSERT INTO schema_migrations VALUES('0');
