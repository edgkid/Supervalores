update t_cliente_x_tarifa set fecha = '1971-01-01' where fecha = '0000-00-00';
update t_cliente_x_tarifa set fecha_registro = '1971-01-01' where fecha_registro = '0000-00-00';
update t_clientes set prospecto_date_in = '1971-01-01' where prospecto_date_in = '0000-00-00';
update t_clientes set prospecto_date_out = '1971-01-01' where prospecto_date_out = '0000-00-00';
update t_clientes set fecha_resolucion = '1971-01-01' where fecha_resolucion = '0000-00-00';
update t_clientes set fecha_notificacion = '1971-01-01' where fecha_notificacion = '0000-00-00';
update t_clientes set fecha_vencimiento = '1971-01-01' where fecha_vencimiento = '0000-00-00';
update t_clientes set fecha_vencimiento_fact = '1971-01-01' where fecha_vencimiento_fact = '0000-00-00';
update t_clientes set fecha_registro = '1971-01-01' where fecha_registro = '0000-00-00';
update t_clientes set prospecto_date_in = '1971-01-01' where prospecto_date_in = '0000-01-01';
update t_clientes set prospecto_date_out = '1971-01-01' where prospecto_date_out = '0000-01-01';
update t_clientes set fecha_resolucion = '1971-01-01' where fecha_resolucion = '0000-01-01';
update t_clientes set fecha_notificacion = '1971-01-01' where fecha_notificacion = '0000-01-01';
update t_clientes set fecha_vencimiento = '1971-01-01' where fecha_vencimiento = '0000-01-01';
update t_clientes set fecha_vencimiento_fact = '1971-01-01' where fecha_vencimiento_fact = '0000-01-01';
update t_clientes set fecha_registro = '1971-01-01' where fecha_registro = '0000-01-01';
update t_estado_cuenta set fecha_generacion = '1971-01-01' where fecha_generacion = '0000-00-00 00:00:00';
update t_estado_cuenta set fecha_vencimiento = '1971-01-01' where fecha_vencimiento = '0000-00-00 00:00:00';
update t_estado_cuenta_temp set fecha_generacion = '1971-01-01' where fecha_generacion = '0000-00-00 00:00:00';
update t_estado_cuenta_temp set fecha_vencimiento = '1971-01-01' where fecha_vencimiento = '0000-00-00 00:00:00';
update t_facturas set fecha_factura = '1971-01-01' where fecha_factura = '0000-00-00';
update t_facturas set fecha_vencimiento = '1971-01-01' where fecha_vencimiento = '0000-00-00';
update t_facturas set fecha_registro = '1971-01-01' where fecha_registro = '0000-00-00';
update t_facturas set fecha_erroneo = '1971-01-01' where fecha_erroneo = '0000-00-00';
update t_facturas set next_fecha_recargo = '1971-01-01' where next_fecha_recargo = '0000-00-00';
update t_facturas_temp set fecha_factura = '1971-01-01' where fecha_factura = '0000-00-00';
update t_facturas_temp set fecha_vencimiento = '1971-01-01' where fecha_vencimiento = '0000-00-00';
update t_facturas_temp set fecha_registro = '1971-01-01' where fecha_registro = '0000-00-00';
update t_facturas_temp set fecha_erroneo = '1971-01-01' where fecha_erroneo = '0000-00-00';
update t_facturas_temp set next_fecha_recargo = '1971-01-01' where next_fecha_recargo = '0000-00-00';
update t_recibos set fecha_pago = '1971-01-01' where fecha_pago = '0000-00-00';
update t_recibos set fecha_registro = '1971-01-01' where fecha_registro = '0000-00-00';
update t_recibos set fecha_erroneo = '1971-01-01' where fecha_erroneo = '0000-00-00';
update temp_t_recibos set fecha_pago = '1971-01-01' where fecha_pago = '0000-00-00';
update t_usuario set fecha_creado = '1971-01-01' where fecha_creado = '0000-00-00 00:00:00';
update t_usuario set ultimo_login = '1971-01-01' where ultimo_login = '0000-00-00 00:00:00';
update t_usuario set end_hash = '1971-01-01' where end_hash = '0000-00-00 00:00:00';
update temp_analisis_est_cta set fecha_generacion = '1971-01-01' where fecha_generacion = '0000-00-00 00:00:00';
update temp_analisis_est_cta set fecha_vencimiento = '1971-01-01' where fecha_vencimiento = '0000-00-00 00:00:00';

INSERT t_clientes (idt_clientes, codigo)
SELECT cli.idt_clientes, matsh.`ID_CASA_VALOR` AS codigo 
FROM t_clientes cli
JOIN t_cliente_matsh matsh ON cli.idt_clientes = matsh.idt_clientes
ON DUPLICATE KEY UPDATE t_clientes.codigo = VALUES(codigo);