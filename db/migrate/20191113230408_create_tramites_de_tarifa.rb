class CreateTramitesDeTarifa < ActiveRecord::Migration[5.2]
  def self.up
    self.connection.execute %Q( CREATE OR REPLACE VIEW tramites_de_tarifa_view AS
      SELECT ts.id, COUNT(ts.id) cantidad, fecha_notificacion, codigo, nombre, descripcion, ts.tipo
      FROM t_tarifa_servicios ts
      INNER JOIN t_factura_detalles fd ON fd.t_tarifa_servicio_id = ts.id
      INNER JOIN t_facturas f ON fd.t_factura_id = f.id
      GROUP BY ts.id, fecha_notificacion, codigo, nombre, descripcion, ts.tipo;
    )
  end

  def self.down
    self.connection.execute "DROP VIEW IF EXISTS tramites_de_tarifa_view;"
  end
end
