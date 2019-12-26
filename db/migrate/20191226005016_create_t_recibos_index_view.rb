class CreateTRecibosIndexView < ActiveRecord::Migration[5.2]
  def self.up
    self.connection.execute %Q( CREATE OR REPLACE VIEW t_recibos_view AS
      SELECT
        rec.id, fecha_pago, forma_pago,
        COALESCE(e.razon_social, o.razon_social, CONCAT(p.nombre, ' ', p.apellido)) razon_social,
        pago_recibido, pago_pendiente, monto_acreditado, f.id t_factura_id
      FROM t_recibos rec
      INNER JOIN t_metodo_pagos mp ON mp.id = rec.t_metodo_pago_id
      INNER JOIN t_facturas f ON rec.t_factura_id = f.id
      LEFT OUTER JOIN t_resolucions res ON f.t_resolucion_id = res.id
      INNER JOIN t_clientes c ON res.t_cliente_id = c.id OR f.t_cliente_id = c.id
      LEFT OUTER JOIN t_empresas e ON e.id = c.persona_id AND c.persona_type = 'TEmpresa'
      LEFT OUTER JOIN t_personas p ON p.id = c.persona_id AND c.persona_type = 'TPersona'
      LEFT OUTER JOIN t_otros    o ON o.id = c.persona_id AND c.persona_type = 'TOtro';
    )
  end

  def self.down
    self.connection.execute "DROP VIEW IF EXISTS t_recibos_view;"
  end
end
