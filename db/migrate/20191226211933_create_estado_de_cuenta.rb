class CreateEstadoDeCuenta < ActiveRecord::Migration[5.2]
  def self.up
    self.connection.execute %Q( CREATE OR REPLACE VIEW estado_de_cuenta_view AS
      SELECT
        f.id, f.fecha_notificacion, f.fecha_vencimiento, rec.id t_recibo_id,
        p.descripcion cuenta, ts.nombre, ts.descripcion, rec.pago_pendiente,
        rec.pago_recibido, rec.monto_acreditado, f.total_factura, c.id t_cliente_id
        
      FROM t_facturas f
      LEFT OUTER JOIN t_recibos rec ON rec.t_factura_id = f.id
      LEFT OUTER JOIN t_factura_detalles fd ON fd.t_factura_id = f.id
      INNER JOIN t_tarifa_servicios ts ON fd.t_tarifa_servicio_id = ts.id
      INNER JOIN t_presupuestos p ON ts.t_presupuesto_id = p.id
      LEFT OUTER JOIN t_resolucions res ON f.t_resolucion_id = res.id
      INNER JOIN t_clientes c ON f.t_cliente_id = c.id OR res.t_cliente_id = c.id;
    )
  end

  def self.down
    self.connection.execute "DROP VIEW IF EXISTS estado_de_cuenta_view;"
  end
end
