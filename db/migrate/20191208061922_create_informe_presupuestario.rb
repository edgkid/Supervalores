class CreateInformePresupuestario < ActiveRecord::Migration[5.2]
  def self.up
    self.connection.execute %Q( CREATE OR REPLACE VIEW informe_presupuestario_view AS
      SELECT
        p.id, p.codigo, p.descripcion, f.fecha_notificacion,
        CASE
        WHEN rec.t_factura_id iS NOT NULL
        THEN rec.pago_pendiente
        ELSE f.total_factura
        END pago_pendiente
      FROM t_presupuestos p
      INNER JOIN t_tarifa_servicios ts ON ts.t_presupuesto_id = p.id
      INNER JOIN t_factura_detalles fd ON fd.t_tarifa_servicio_id = ts.id
      RIGHT OUTER JOIN t_facturas f ON fd.t_factura_id = f.id
      LEFT OUTER JOIN t_recibos rec ON rec.t_factura_id = f.id;
    )
  end

  def self.down
    self.connection.execute "DROP VIEW IF EXISTS informe_presupuestario_view;"
  end
end
