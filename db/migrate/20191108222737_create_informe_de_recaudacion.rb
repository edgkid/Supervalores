class CreateInformeDeRecaudacion < ActiveRecord::Migration[5.2]
  def self.up
    self.connection.execute %Q( CREATE OR REPLACE VIEW informe_de_recaudacion_view AS
      SELECT
        f.id factura_id, MAX(rec.id) recibo_id,
        MAX(COALESCE(e.razon_social, o.razon_social, CONCAT(p.nombre, ' ', p.apellido))) razon_social,
        MAX(COALESCE(e.rif, o.identificacion, p.cedula)) identificacion,
        MAX(res.codigo) res, MAX(f.fecha_notificacion) fecha_notificacion,
        MAX(mp.forma_pago) forma_pago, MAX(f.total_factura) total_factura,
        CASE
        WHEN MAX(rec.pago_pendiente) <= 0 THEN
          'Pagada'
        ELSE
          'No Pagada'
        END AS estado
      FROM t_facturas f
      INNER JOIN t_recibos rec ON rec.t_factura_id = f.id
      INNER JOIN t_metodo_pagos mp ON mp.id = rec.t_metodo_pago_id
      LEFT JOIN t_resolucions res ON res.id = f.t_resolucion_id
      LEFT JOIN t_clientes c ON c.id = res.t_cliente_id OR c.id = f.t_cliente_id
      LEFT JOIN t_empresas e ON e.id = c.persona_id AND c.persona_type = 'TEmpresa'
      LEFT JOIN t_personas p ON p.id = c.persona_id AND c.persona_type = 'TPersona'
      LEFT JOIN t_otros    o ON o.id = c.persona_id AND c.persona_type = 'TOtro'
      GROUP BY f.id;
    )
  end

  def self.down
    self.connection.execute "DROP VIEW IF EXISTS informe_de_recaudacion_view;"
  end
end
