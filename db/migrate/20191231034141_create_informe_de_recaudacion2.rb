class CreateInformeDeRecaudacion2 < ActiveRecord::Migration[5.2]
  def self.up
    self.connection.execute %Q( CREATE OR REPLACE VIEW informe_de_recaudacion_view AS
      SELECT
        rec.id, f.id t_factura_id, rec.fecha_pago, mp.forma_pago,
        COALESCE(e.rif, o.identificacion, p.cedula) identificacion,
        COALESCE(e.razon_social, o.razon_social, CONCAT(p.nombre, ' ', p.apellido)) razon_social,
        res.resolucion, rec.pago_recibido, rec.pago_pendiente, rec.monto_acreditado
      FROM t_recibos rec
      INNER JOIN t_facturas f ON f.id = rec.t_factura_id
      INNER JOIN t_metodo_pagos mp ON mp.id = rec.t_metodo_pago_id
      LEFT OUTER JOIN t_resolucions res ON res.id = f.t_resolucion_id
      INNER JOIN t_clientes c ON c.id = res.t_cliente_id OR c.id = f.t_cliente_id
      LEFT OUTER JOIN t_empresas e ON e.id = c.persona_id AND c.persona_type = 'TEmpresa'
      LEFT OUTER JOIN t_personas p ON p.id = c.persona_id AND c.persona_type = 'TPersona'
      LEFT OUTER JOIN t_otros    o ON o.id = c.persona_id AND c.persona_type = 'TOtro';
    )
  end

  def self.down
    self.connection.execute "DROP VIEW IF EXISTS informe_de_recaudacion_view;"
  end
end
