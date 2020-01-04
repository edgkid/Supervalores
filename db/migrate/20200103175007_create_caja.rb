class CreateCaja < ActiveRecord::Migration[5.2]
  def self.up
    self.connection.execute %Q( CREATE OR REPLACE VIEW caja_view AS
      SELECT
        rec.id, res.resolucion, rec.fecha_pago, rec.pago_pendiente, rec.pago_recibido,
        COALESCE(e.rif, o.identificacion, p.cedula) identificacion,
        COALESCE(e.razon_social, o.razon_social, CONCAT(p.nombre, ' ', p.apellido)) razon_social,
        CONCAT(u.nombre, ' ', u.apellido) user_name, f.id t_factura_id
      FROM t_recibos rec
      INNER JOIN users u ON u.id = rec.user_id
      INNER JOIN t_facturas f ON f.id = rec.t_factura_id
      LEFT OUTER JOIN t_resolucions res ON res.id = f.t_resolucion_id
      INNER JOIN t_clientes c ON c.id = res.t_cliente_id OR c.id = f.t_cliente_id
      LEFT OUTER JOIN t_empresas e ON e.id = c.persona_id AND c.persona_type = 'TEmpresa'
      LEFT OUTER JOIN t_personas p ON p.id = c.persona_id AND c.persona_type = 'TPersona'
      LEFT OUTER JOIN t_otros    o ON o.id = c.persona_id AND c.persona_type = 'TOtro';
    )
  end

  def self.down
    self.connection.execute "DROP VIEW IF EXISTS caja_view;"
  end
end
