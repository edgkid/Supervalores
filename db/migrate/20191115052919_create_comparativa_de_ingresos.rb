class CreateComparativaDeIngresos < ActiveRecord::Migration[5.2]
  def self.up
    self.connection.execute %Q( CREATE OR REPLACE VIEW comparativa_ingresos_view AS
      SELECT
        rec.id, f.id t_factura_id, c.id t_cliente_id, ts.id t_tarifa_servicio_id,
        fecha_pago, pago_recibido, cuenta_desc detalle_factura,
        ts.nombre nombre_servicio, ts.descripcion descripcion_servicio,
        COALESCE(e.rif, o.identificacion, p.cedula) identificacion,
        COALESCE(e.razon_social, o.razon_social, CONCAT(p.nombre, ' ', p.apellido)) razon_social
      FROM t_recibos rec
      INNER JOIN t_facturas f ON rec.t_factura_id = f.id
      INNER JOIN t_factura_detalles fd ON fd.t_factura_id = f.id
      INNER JOIN t_tarifa_servicios ts ON fd.t_tarifa_servicio_id = ts.id
      LEFT OUTER JOIN t_resolucions res ON f.t_resolucion_id = res.id
      INNER JOIN t_clientes c ON f.t_cliente_id = c.id OR res.t_cliente_id = c.id
      LEFT OUTER JOIN t_empresas e ON e.id = c.persona_id AND c.persona_type = 'TEmpresa'
      LEFT OUTER JOIN t_personas p ON p.id = c.persona_id AND c.persona_type = 'TPersona'
      LEFT OUTER JOIN t_otros    o ON o.id = c.persona_id AND c.persona_type = 'TOtro'
      WHERE rec.pago_pendiente <= 0;
    )
  end

  def self.down
    self.connection.execute "DROP VIEW IF EXISTS comparativa_ingresos_view;"
  end
end
