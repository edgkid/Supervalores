class CreateInformeDeCuentasXCobrar < ActiveRecord::Migration[5.2]
  def self.up
    self.connection.execute %Q( CREATE OR REPLACE VIEW informe_de_cuentas_x_cobrar_view AS
      WITH f_agrupadas AS (
        SELECT f.id t_factura_id, f.t_resolucion_id, MAX(rec.id) t_recibo_id
        FROM t_facturas f
        LEFT OUTER JOIN t_recibos rec ON rec.t_factura_id = f.id
        GROUP BY f.id, f.t_resolucion_id
      ), f_con_rango AS
      (
        SELECT
          tc.id, tc.descripcion, c.id t_cliente_id, f.id t_factura_id,

          CASE
          WHEN (rec.fecha_pago IS NULL AND CURRENT_DATE - f.fecha_notificacion BETWEEN 0 AND 30)
          OR (rec.fecha_pago - f.fecha_notificacion BETWEEN 0 AND 30) THEN
            COALESCE(rec.pago_pendiente, f.total_factura)
          ELSE 0 END dias_0_30,

          CASE
          WHEN (rec.fecha_pago IS NULL AND CURRENT_DATE - f.fecha_notificacion BETWEEN 31 AND 60)
          OR (rec.fecha_pago - f.fecha_notificacion BETWEEN 31 AND 60) THEN
            COALESCE(rec.pago_pendiente, f.total_factura)
          ELSE 0 END dias_31_60,

          CASE
          WHEN (rec.fecha_pago IS NULL AND CURRENT_DATE - f.fecha_notificacion BETWEEN 61 AND 90)
          OR (rec.fecha_pago - f.fecha_notificacion BETWEEN 61 AND 90) THEN
            COALESCE(rec.pago_pendiente, f.total_factura)
          ELSE 0 END dias_61_90,

          CASE
          WHEN (rec.fecha_pago IS NULL AND CURRENT_DATE - f.fecha_notificacion BETWEEN 91 AND 120)
          OR (rec.fecha_pago - f.fecha_notificacion BETWEEN 91 AND 120) THEN
            COALESCE(rec.pago_pendiente, f.total_factura)
          ELSE 0 END dias_91_120,

          CASE
          WHEN (rec.fecha_pago IS NULL AND CURRENT_DATE - f.fecha_notificacion > 120)
          OR (rec.fecha_pago - f.fecha_notificacion > 120) THEN
            COALESCE(rec.pago_pendiente, f.total_factura)
          ELSE 0 END dias_mas_de_120

        FROM f_agrupadas
        INNER JOIN t_resolucions res ON f_agrupadas.t_resolucion_id = res.id
        INNER JOIN t_clientes c ON res.t_cliente_id = c.id
        INNER JOIN t_tipo_clientes tc ON res.t_tipo_cliente_id = tc.id
        INNER JOIN t_facturas f ON f_agrupadas.t_factura_id = f.id
        LEFT OUTER JOIN t_recibos rec ON f_agrupadas.t_recibo_id = rec.id
      )

      SELECT
        id, descripcion, COUNT(t_cliente_id) cantidad_clientes, COUNT(t_factura_id) cantidad_facturas,
        SUM(dias_0_30) dias_0_30, SUM(dias_31_60) dias_31_60, SUM(dias_61_90) dias_61_90,
        SUM(dias_91_120) dias_91_120, SUM(dias_mas_de_120) dias_mas_de_120,
        (SUM(dias_0_30) + SUM(dias_31_60) + SUM(dias_61_90) + SUM(dias_91_120) + SUM(dias_mas_de_120)) total
        
      FROM f_con_rango
      GROUP BY id, descripcion;
    )
  end

  def self.down
    self.connection.execute "DROP VIEW IF EXISTS informe_de_cuentas_x_cobrar_view;"
  end
end
