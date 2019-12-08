class CreateInformePorTiposDeIngreso < ActiveRecord::Migration[5.2]
  def self.up
    self.connection.execute %Q( CREATE OR REPLACE VIEW informe_por_tipos_de_ingreso_view AS
      WITH ultimos_recibos AS (
        SELECT
          f.id, c.codigo, mp.forma_pago, f.total_factura, MAX(rec.id) t_recibo_id,
          COALESCE(e.razon_social, o.razon_social, CONCAT(p.nombre, ' ', p.apellido)) razon_social
        FROM t_facturas f
        INNER JOIN t_recibos rec ON rec.t_factura_id = f.id
        LEFT OUTER JOIN t_resolucions res ON f.t_resolucion_id = res.id
        INNER JOIN t_clientes c ON f.t_cliente_id = c.id OR res.t_cliente_id = c.id
        LEFT OUTER JOIN t_empresas e ON e.id = c.persona_id AND c.persona_type = 'TEmpresa'
        LEFT OUTER JOIN t_personas p ON p.id = c.persona_id AND c.persona_type = 'TPersona'
        LEFT OUTER JOIN t_otros    o ON o.id = c.persona_id AND c.persona_type = 'TOtro'
        INNER JOIN t_metodo_pagos mp ON rec.t_metodo_pago_id = mp.id

        GROUP BY
          f.id, c.codigo, mp.forma_pago, f.total_factura,
          COALESCE(e.razon_social, o.razon_social, CONCAT(p.nombre, ' ', p.apellido))
      )
      SELECT
        ultimos_recibos.*, rec.pago_pendiente, rec.fecha_pago,
        CASE WHEN rec.pago_pendiente <= 0 THEN 'Pagada' ELSE 'No Pagada' END estado
      FROM ultimos_recibos
      INNER JOIN t_recibos rec ON rec.id = ultimos_recibos.t_recibo_id;
    )
  end

  def self.down
    self.connection.execute "DROP VIEW IF EXISTS informe_por_tipos_de_ingreso_view;"
  end
end
