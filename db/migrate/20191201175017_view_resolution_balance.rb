class ViewResolutionBalance < ActiveRecord::Migration[5.2]
  def up
    self.connection.execute %Q( CREATE OR REPLACE VIEW view_resolution_balance AS
      SELECT 
        cli.id t_cliente_id
      , res.id t_resolucion_id
      , res.resolucion
      , sum(COALESCE(rec.pago_recibido, 0)) pagos_recibidos
      , sum(COALESCE(fac.total_factura, 0)) total_facturado
      FROM t_clientes cli
      JOIN t_resolucions res ON cli.id = res.t_cliente_id
      LEFT JOIN t_facturas fac ON res.id = fac.t_resolucion_id
      LEFT JOIN t_recibos rec ON fac.id = rec.t_factura_id
      GROUP BY cli.id, res.id, res.resolucion;
    )
  end

  def down
    self.connection.execute "DROP VIEW IF EXISTS view_client;"
  end
end
