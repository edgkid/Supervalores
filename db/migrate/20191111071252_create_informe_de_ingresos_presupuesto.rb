class CreateInformeDeIngresosPresupuesto < ActiveRecord::Migration[5.2]
  def self.up
    self.connection.execute %Q( CREATE OR REPLACE VIEW informe_de_ingresos_presupuesto_view AS
      WITH meses AS(
        SELECT f.id, fecha_pago,
          CASE EXTRACT(month from fecha_pago) WHEN 1  THEN pago_recibido END pago_enero,
          CASE EXTRACT(month from fecha_pago) WHEN 2  THEN pago_recibido END pago_febrero,
          CASE EXTRACT(month from fecha_pago) WHEN 3  THEN pago_recibido END pago_marzo,
          CASE EXTRACT(month from fecha_pago) WHEN 4  THEN pago_recibido END pago_abril,
          CASE EXTRACT(month from fecha_pago) WHEN 5  THEN pago_recibido END pago_mayo,
          CASE EXTRACT(month from fecha_pago) WHEN 6  THEN pago_recibido END pago_junio,
          CASE EXTRACT(month from fecha_pago) WHEN 7  THEN pago_recibido END pago_julio,
          CASE EXTRACT(month from fecha_pago) WHEN 8  THEN pago_recibido END pago_agosto,
          CASE EXTRACT(month from fecha_pago) WHEN 9  THEN pago_recibido END pago_septiembre,
          CASE EXTRACT(month from fecha_pago) WHEN 10 THEN pago_recibido END pago_octubre,
          CASE EXTRACT(month from fecha_pago) WHEN 11 THEN pago_recibido END pago_noviembre,
          CASE EXTRACT(month from fecha_pago) WHEN 12 THEN pago_recibido END pago_diciembre
        FROM t_recibos r
        INNER JOIN t_facturas f ON r.t_factura_id = f.id
      )
      SELECT id t_factura_id, MIN(fecha_pago) primer_pago, MAX(fecha_pago) ultimo_pago,
        SUM(pago_enero)   enero,   SUM(pago_febrero)   febrero,   SUM(pago_marzo)      marzo,
        SUM(pago_abril)   abril,   SUM(pago_mayo)      mayo,      SUM(pago_junio)      junio,
        SUM(pago_julio)   julio,   SUM(pago_agosto)    agosto,    SUM(pago_septiembre) septiembre,
        SUM(pago_octubre) octubre, SUM(pago_noviembre) noviembre, SUM(pago_diciembre)  diciembre,
      (
        COALESCE(SUM(pago_enero), 0)   + COALESCE(SUM(pago_febrero), 0)   + COALESCE(SUM(pago_marzo), 0) +
        COALESCE(SUM(pago_abril), 0)   + COALESCE(SUM(pago_mayo), 0)      + COALESCE(SUM(pago_junio), 0) +
        COALESCE(SUM(pago_julio), 0)   + COALESCE(SUM(pago_agosto), 0)    + COALESCE(SUM(pago_septiembre), 0) +
        COALESCE(SUM(pago_octubre), 0) + COALESCE(SUM(pago_noviembre), 0) + COALESCE(SUM(pago_diciembre), 0)
      ) total
      FROM meses
      GROUP BY id;
    )
  end

  def self.down
    self.connection.execute "DROP VIEW IF EXISTS informe_de_ingresos_presupuesto_view;"
  end
end
