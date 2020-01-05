class CreateCuentasXCobrarXCliente < ActiveRecord::Migration[5.2]
  def self.up
    self.connection.execute %Q( CREATE OR REPLACE VIEW cuentas_x_cobrar_x_cliente_view AS
      WITH dias_agrupados AS(
        SELECT
          f.id, rec.id t_recibo_id, c.id t_cliente_id, f.fecha_notificacion,
          COALESCE(e.razon_social, o.razon_social, CONCAT(p.nombre, ' ', p.apellido)) razon_social,
          CASE
          WHEN (rec.pago_pendiente IS NULL AND (CURRENT_DATE - f.fecha_notificacion BETWEEN 0 AND 30))
            THEN f.total_factura
          WHEN (rec.pago_pendiente IS NOT NULL AND (CURRENT_DATE - f.fecha_notificacion BETWEEN 0 AND 30))
            THEN rec.pago_pendiente
          ELSE 0
          END dias_0_30,
          CASE
          WHEN (rec.pago_pendiente IS NULL AND (CURRENT_DATE - f.fecha_notificacion BETWEEN 31 AND 60))
            THEN f.total_factura
          WHEN (rec.pago_pendiente IS NOT NULL AND (CURRENT_DATE - f.fecha_notificacion BETWEEN 31 AND 60))
            THEN rec.pago_pendiente
          ELSE 0
          END dias_31_60,
          CASE
          WHEN (rec.pago_pendiente IS NULL AND (CURRENT_DATE - f.fecha_notificacion BETWEEN 61 AND 90))
            THEN f.total_factura
          WHEN (rec.pago_pendiente IS NOT NULL AND (CURRENT_DATE - f.fecha_notificacion BETWEEN 61 AND 90))
            THEN rec.pago_pendiente
          ELSE 0
          END dias_61_90,
          CASE
          WHEN (rec.pago_pendiente IS NULL AND (CURRENT_DATE - f.fecha_notificacion BETWEEN 91 AND 120))
            THEN f.total_factura
          WHEN (rec.pago_pendiente IS NOT NULL AND (CURRENT_DATE - f.fecha_notificacion BETWEEN 91 AND 120))
            THEN rec.pago_pendiente
          ELSE 0
          END dias_91_120,
          CASE
          WHEN (rec.pago_pendiente IS NULL AND (CURRENT_DATE - f.fecha_notificacion > 120))
            THEN f.total_factura
          WHEN (rec.pago_pendiente IS NOT NULL AND (CURRENT_DATE - f.fecha_notificacion > 120))
            THEN rec.pago_pendiente
          ELSE 0
          END dias_mas_de_120
        FROM t_facturas f
        INNER JOIN t_resolucions res ON res.id = f.t_resolucion_id
        INNER JOIN t_clientes c ON c.id = res.t_cliente_id
        LEFT OUTER JOIN t_empresas e ON e.id = c.persona_id AND c.persona_type = 'TEmpresa'
        LEFT OUTER JOIN t_personas p ON p.id = c.persona_id AND c.persona_type = 'TPersona'
        LEFT OUTER JOIN t_otros    o ON o.id = c.persona_id AND c.persona_type = 'TOtro'
        LEFT OUTER JOIN t_recibos rec ON f.id = rec.t_factura_id

        WHERE rec.ultimo_recibo = true OR rec.t_factura_id IS NULL
      )
      SELECT
        t_cliente_id,
        SUM(dias_0_30) dias_0_30, SUM(dias_31_60) dias_31_60, SUM(dias_61_90) dias_61_90,
        SUM(dias_91_120) dias_91_120, SUM(dias_mas_de_120) dias_mas_de_120,
        (SUM(dias_0_30) + SUM(dias_31_60) + SUM(dias_61_90) + SUM(dias_91_120) + SUM(dias_mas_de_120)) total
      FROM dias_agrupados

      GROUP BY t_cliente_id;
    )
  end

  def self.down
    self.connection.execute "DROP VIEW IF EXISTS cuentas_x_cobrar_x_cliente_view;"
  end
end
