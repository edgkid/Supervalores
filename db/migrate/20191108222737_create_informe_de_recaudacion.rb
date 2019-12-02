class CreateInformeDeRecaudacion < ActiveRecord::Migration[5.2]
  def self.up
    self.connection.execute %Q( CREATE OR REPLACE VIEW informe_de_recaudacion_view AS
      WITH f_agrupadas AS (
        SELECT
          f.id, f.fecha_notificacion, f.total_factura, mp.forma_pago,
          COALESCE(e.rif, o.identificacion, p.cedula) identificacion, res.resolucion,
          COALESCE(e.razon_social, o.razon_social, CONCAT(p.nombre, ' ', p.apellido)) razon_social,
          MAX(rec.id) t_recibo_id
        FROM t_facturas f

        INNER JOIN t_recibos rec ON rec.t_factura_id = f.id
        LEFT OUTER JOIN t_metodo_pagos mp ON mp.id = rec.t_metodo_pago_id
        LEFT OUTER JOIN t_resolucions res ON res.id = f.t_resolucion_id
        LEFT OUTER JOIN t_clientes c ON c.id = res.t_cliente_id OR c.id = f.t_cliente_id
        LEFT OUTER JOIN t_empresas e ON e.id = c.persona_id AND c.persona_type = 'TEmpresa'
        LEFT OUTER JOIN t_personas p ON p.id = c.persona_id AND c.persona_type = 'TPersona'
        LEFT OUTER JOIN t_otros    o ON o.id = c.persona_id AND c.persona_type = 'TOtro'

        GROUP BY
          f.id, f.fecha_notificacion, f.total_factura, mp.forma_pago,
          COALESCE(e.rif, o.identificacion, p.cedula), res.resolucion,
          COALESCE(e.razon_social, o.razon_social, CONCAT(p.nombre, ' ', p.apellido))
      )
      SELECT f_agrupadas.*,
        CASE
        WHEN rec.pago_pendiente <= 0 THEN
          'Pagada'
        ELSE
          'No Pagada'
        END AS estado
      FROM f_agrupadas
      INNER JOIN t_recibos rec ON rec.id = f_agrupadas.t_recibo_id;
    )
  end

  def self.down
    self.connection.execute "DROP VIEW IF EXISTS informe_de_recaudacion_view;"
  end
end
