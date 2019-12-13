class CreateInformeDeIngresosPresupuesto2 < ActiveRecord::Migration[5.2]
  def self.up
    self.connection.execute %Q( CREATE OR REPLACE VIEW informe_de_ingresos_presupuesto_view AS
      SELECT
        p.id, p.codigo, p.descripcion, extract(year from rec.fecha_pago) anio_pago,
        SUM(CASE EXTRACT(month from fecha_pago) WHEN 1  THEN pago_recibido END) pago_enero,
        SUM(CASE EXTRACT(month from fecha_pago) WHEN 2  THEN pago_recibido END) pago_febrero,
        SUM(CASE EXTRACT(month from fecha_pago) WHEN 3  THEN pago_recibido END) pago_marzo,
        SUM(CASE EXTRACT(month from fecha_pago) WHEN 4  THEN pago_recibido END) pago_abril,
        SUM(CASE EXTRACT(month from fecha_pago) WHEN 5  THEN pago_recibido END) pago_mayo,
        SUM(CASE EXTRACT(month from fecha_pago) WHEN 6  THEN pago_recibido END) pago_junio,
        SUM(CASE EXTRACT(month from fecha_pago) WHEN 7  THEN pago_recibido END) pago_julio,
        SUM(CASE EXTRACT(month from fecha_pago) WHEN 8  THEN pago_recibido END) pago_agosto,
        SUM(CASE EXTRACT(month from fecha_pago) WHEN 9  THEN pago_recibido END) pago_septiembre,
        SUM(CASE EXTRACT(month from fecha_pago) WHEN 10 THEN pago_recibido END) pago_octubre,
        SUM(CASE EXTRACT(month from fecha_pago) WHEN 11 THEN pago_recibido END) pago_noviembre,
        SUM(CASE EXTRACT(month from fecha_pago) WHEN 12 THEN pago_recibido END) pago_diciembre,
        
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
      FROM t_presupuestos p
      INNER JOIN t_tarifa_servicios ts ON ts.t_presupuesto_id = p.id
      INNER JOIN t_factura_detalles fd ON fd.t_tarifa_servicio_id = ts.id
      INNER JOIN t_facturas f ON fd.t_factura_id = f.id
      INNER JOIN t_recibos rec ON rec.t_factura_id = f.id

      GROUP BY p.id, p.codigo, p.descripcion, extract(year from rec.fecha_pago);
    )
  end

  def self.down
    self.connection.execute "DROP VIEW IF EXISTS informe_de_ingresos_presupuesto_view;"
  end
end
