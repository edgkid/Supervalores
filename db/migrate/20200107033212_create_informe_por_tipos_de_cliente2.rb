class CreateInformePorTiposDeCliente2 < ActiveRecord::Migration[5.2]
  def self.up
    self.connection.execute %Q( CREATE OR REPLACE VIEW informe_por_tipos_de_cliente_view AS
      SELECT
        tc.id, tc.descripcion, rec.fecha_pago,
        SUM(CASE EXTRACT(month from fecha_pago) WHEN 1  THEN pago_recibido ELSE 0 END) pago_enero,
        SUM(CASE EXTRACT(month from fecha_pago) WHEN 2  THEN pago_recibido ELSE 0 END) pago_febrero,
        SUM(CASE EXTRACT(month from fecha_pago) WHEN 3  THEN pago_recibido ELSE 0 END) pago_marzo,
        SUM(CASE EXTRACT(month from fecha_pago) WHEN 4  THEN pago_recibido ELSE 0 END) pago_abril,
        SUM(CASE EXTRACT(month from fecha_pago) WHEN 5  THEN pago_recibido ELSE 0 END) pago_mayo,
        SUM(CASE EXTRACT(month from fecha_pago) WHEN 6  THEN pago_recibido ELSE 0 END) pago_junio,
        SUM(CASE EXTRACT(month from fecha_pago) WHEN 7  THEN pago_recibido ELSE 0 END) pago_julio,
        SUM(CASE EXTRACT(month from fecha_pago) WHEN 8  THEN pago_recibido ELSE 0 END) pago_agosto,
        SUM(CASE EXTRACT(month from fecha_pago) WHEN 9  THEN pago_recibido ELSE 0 END) pago_septiembre,
        SUM(CASE EXTRACT(month from fecha_pago) WHEN 10 THEN pago_recibido ELSE 0 END) pago_octubre,
        SUM(CASE EXTRACT(month from fecha_pago) WHEN 11 THEN pago_recibido ELSE 0 END) pago_noviembre,
        SUM(CASE EXTRACT(month from fecha_pago) WHEN 12 THEN pago_recibido ELSE 0 END) pago_diciembre,

        SUM(COALESCE(CASE EXTRACT(month from fecha_pago) WHEN 1  THEN pago_recibido END, 0)) +
        SUM(COALESCE(CASE EXTRACT(month from fecha_pago) WHEN 2  THEN pago_recibido END, 0)) +
        SUM(COALESCE(CASE EXTRACT(month from fecha_pago) WHEN 3  THEN pago_recibido END, 0)) +
        SUM(COALESCE(CASE EXTRACT(month from fecha_pago) WHEN 4  THEN pago_recibido END, 0)) +
        SUM(COALESCE(CASE EXTRACT(month from fecha_pago) WHEN 5  THEN pago_recibido END, 0)) +
        SUM(COALESCE(CASE EXTRACT(month from fecha_pago) WHEN 6  THEN pago_recibido END, 0)) +
        SUM(COALESCE(CASE EXTRACT(month from fecha_pago) WHEN 7  THEN pago_recibido END, 0)) +
        SUM(COALESCE(CASE EXTRACT(month from fecha_pago) WHEN 8  THEN pago_recibido END, 0)) +
        SUM(COALESCE(CASE EXTRACT(month from fecha_pago) WHEN 9  THEN pago_recibido END, 0)) +
        SUM(COALESCE(CASE EXTRACT(month from fecha_pago) WHEN 10 THEN pago_recibido END, 0)) +
        SUM(COALESCE(CASE EXTRACT(month from fecha_pago) WHEN 11 THEN pago_recibido END, 0)) +
        SUM(COALESCE(CASE EXTRACT(month from fecha_pago) WHEN 12 THEN pago_recibido END, 0)) total
              
      FROM t_tipo_clientes tc
      INNER JOIN t_resolucions res ON res.t_tipo_cliente_id = tc.id
      INNER JOIN t_facturas f ON f.t_resolucion_id = res.id
      INNER JOIN t_recibos rec ON rec.t_factura_id = f.id

      GROUP BY tc.id, tc.descripcion, rec.fecha_pago;
    )
  end

  def self.down
    self.connection.execute "DROP VIEW IF EXISTS informe_por_tipos_de_cliente_view;"
  end
end
