class CreateInformeConsolidadoDeIngresos < ActiveRecord::Migration[5.2]
  def self.up
    self.connection.execute %Q( CREATE OR REPLACE VIEW informe_consolidado_de_ingresos_view AS
      SELECT
        rec.id, rec.justificacion, rec.pago_recibido, rec.fecha_pago,
        f.id t_factura_id, f.fecha_notificacion, f.fecha_vencimiento,
        COALESCE(e.rif, o.identificacion, p.cedula) identificacion,
        COALESCE(e.razon_social, o.razon_social, CONCAT(p.nombre, ' ', p.apellido)) razon_social,
        tc.descripcion tipo_cliente
      FROM t_recibos rec
      INNER JOIN t_facturas f ON rec.t_factura_id = f.id
      LEFT OUTER JOIN t_resolucions res ON f.t_resolucion_id = res.id
      INNER JOIN t_clientes c ON res.t_cliente_id = c.id OR f.t_cliente_id = c.id
      INNER JOIN t_tipo_clientes tc ON res.t_tipo_cliente_id = tc.id
      LEFT OUTER JOIN t_empresas e ON e.id = c.persona_id AND c.persona_type = 'TEmpresa'
      LEFT OUTER JOIN t_personas p ON p.id = c.persona_id AND c.persona_type = 'TPersona'
      LEFT OUTER JOIN t_otros    o ON o.id = c.persona_id AND c.persona_type = 'TOtro';
    )
  end

  def self.down
    self.connection.execute "DROP VIEW IF EXISTS informe_consolidado_de_ingresos_view;"
  end
end
