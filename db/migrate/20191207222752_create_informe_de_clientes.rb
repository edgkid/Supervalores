class CreateInformeDeClientes < ActiveRecord::Migration[5.2]
  def self.up
    self.connection.execute %Q( CREATE OR REPLACE VIEW informe_de_clientes_view AS
      SELECT
        c.id, COALESCE(e.rif, o.identificacion, p.cedula) identificacion,
        COALESCE(e.razon_social, o.razon_social, CONCAT(p.nombre, ' ', p.apellido)) razon_social,
        f.fecha_notificacion, f.fecha_vencimiento, r.id t_resolucion_id, r.resolucion,
        f.recargo, f.total_factura, tc.id t_tipo_cliente_id
      FROM t_clientes c
      LEFT OUTER JOIN t_resolucions r ON r.t_cliente_id = c.id
      INNER JOIN t_tipo_clientes tc ON r.t_tipo_cliente_id = tc.id
      INNER JOIN t_facturas f ON f.t_resolucion_id = r.id OR f.t_cliente_id = tc.id
      LEFT OUTER JOIN t_empresas e ON e.id = c.persona_id AND c.persona_type = 'TEmpresa'
      LEFT OUTER JOIN t_personas p ON p.id = c.persona_id AND c.persona_type = 'TPersona'
      LEFT OUTER JOIN t_otros    o ON o.id = c.persona_id AND c.persona_type = 'TOtro'
    )
  end

  def self.down
    self.connection.execute "DROP VIEW IF EXISTS informe_de_clientes_view;"
  end
end
