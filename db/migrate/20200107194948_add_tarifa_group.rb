class AddTarifaGroup < ActiveRecord::Migration[5.2]
  def change
    self.connection.execute %Q(
      DROP VIEW IF EXISTS informe_presupuestario_view;
      DROP VIEW IF EXISTS estado_de_cuenta_view;
      DROP VIEW IF EXISTS informe_de_ingresos_presupuesto_view;
    )

    remove_column :t_tarifa_servicios, :t_presupuesto_id

    add_column :t_tarifa_servicios, :t_tarifa_servicio_group_id, :bigint, null: false    
    add_index :t_tarifa_servicios, :t_tarifa_servicio_group_id
    add_foreign_key :t_tarifa_servicios, :t_tarifa_servicio_groups

    self.connection.execute %Q( 
    CREATE OR REPLACE VIEW informe_presupuestario_view AS
      SELECT
        p.id, p.codigo, p.descripcion, f.fecha_notificacion,
        CASE
        WHEN rec.t_factura_id iS NOT NULL
        THEN rec.pago_pendiente
        ELSE f.total_factura
        END pago_pendiente
      FROM t_presupuestos p
      INNER JOIN t_tarifa_servicio_groups tsg ON tsg.t_presupuesto_id = p.id
      INNER JOIN t_tarifa_servicios ts ON ts.t_tarifa_servicio_group_id = tsg.id      
      INNER JOIN t_factura_detalles fd ON fd.t_tarifa_servicio_id = ts.id
      RIGHT OUTER JOIN t_facturas f ON fd.t_factura_id = f.id
      LEFT OUTER JOIN t_recibos rec ON rec.t_factura_id = f.id;
    
    CREATE OR REPLACE VIEW estado_de_cuenta_view AS
      SELECT
        f.id, f.fecha_notificacion, f.fecha_vencimiento, rec.id t_recibo_id,
        p.descripcion cuenta, ts.nombre, ts.descripcion, rec.pago_pendiente,
        rec.pago_recibido, rec.monto_acreditado, f.total_factura, c.id t_cliente_id
        
      FROM t_facturas f
      LEFT OUTER JOIN t_recibos rec ON rec.t_factura_id = f.id
      LEFT OUTER JOIN t_factura_detalles fd ON fd.t_factura_id = f.id
      INNER JOIN t_tarifa_servicios ts ON fd.t_tarifa_servicio_id = ts.id
      INNER JOIN t_tarifa_servicio_groups tsg ON ts.t_tarifa_servicio_group_id = tsg.id
      INNER JOIN t_presupuestos p ON tsg.t_presupuesto_id = p.id
      LEFT OUTER JOIN t_resolucions res ON f.t_resolucion_id = res.id
      INNER JOIN t_clientes c ON f.t_cliente_id = c.id OR res.t_cliente_id = c.id;

    CREATE OR REPLACE VIEW informe_de_ingresos_presupuesto_view AS
      SELECT p.id,
      p.codigo,
      p.descripcion,
      date_part('year'::text, rec.fecha_pago) AS anio_pago,
      sum(
          CASE date_part('month'::text, rec.fecha_pago)
              WHEN 1 THEN rec.pago_recibido
              ELSE NULL::double precision
          END) AS pago_enero,
      sum(
          CASE date_part('month'::text, rec.fecha_pago)
              WHEN 2 THEN rec.pago_recibido
              ELSE NULL::double precision
          END) AS pago_febrero,
      sum(
          CASE date_part('month'::text, rec.fecha_pago)
              WHEN 3 THEN rec.pago_recibido
              ELSE NULL::double precision
          END) AS pago_marzo,
      sum(
          CASE date_part('month'::text, rec.fecha_pago)
              WHEN 4 THEN rec.pago_recibido
              ELSE NULL::double precision
          END) AS pago_abril,
      sum(
          CASE date_part('month'::text, rec.fecha_pago)
              WHEN 5 THEN rec.pago_recibido
              ELSE NULL::double precision
          END) AS pago_mayo,
      sum(
          CASE date_part('month'::text, rec.fecha_pago)
              WHEN 6 THEN rec.pago_recibido
              ELSE NULL::double precision
          END) AS pago_junio,
      sum(
          CASE date_part('month'::text, rec.fecha_pago)
              WHEN 7 THEN rec.pago_recibido
              ELSE NULL::double precision
          END) AS pago_julio,
      sum(
          CASE date_part('month'::text, rec.fecha_pago)
              WHEN 8 THEN rec.pago_recibido
              ELSE NULL::double precision
          END) AS pago_agosto,
      sum(
          CASE date_part('month'::text, rec.fecha_pago)
              WHEN 9 THEN rec.pago_recibido
              ELSE NULL::double precision
          END) AS pago_septiembre,
      sum(
          CASE date_part('month'::text, rec.fecha_pago)
              WHEN 10 THEN rec.pago_recibido
              ELSE NULL::double precision
          END) AS pago_octubre,
      sum(
          CASE date_part('month'::text, rec.fecha_pago)
              WHEN 11 THEN rec.pago_recibido
              ELSE NULL::double precision
          END) AS pago_noviembre,
      sum(
          CASE date_part('month'::text, rec.fecha_pago)
              WHEN 12 THEN rec.pago_recibido
              ELSE NULL::double precision
          END) AS pago_diciembre,
      (((((((((((sum(COALESCE(
          CASE date_part('month'::text, rec.fecha_pago)
              WHEN 1 THEN rec.pago_recibido
              ELSE NULL::double precision
          END, (0)::double precision)) + sum(COALESCE(
          CASE date_part('month'::text, rec.fecha_pago)
              WHEN 2 THEN rec.pago_recibido
              ELSE NULL::double precision
          END, (0)::double precision))) + sum(COALESCE(
          CASE date_part('month'::text, rec.fecha_pago)
              WHEN 3 THEN rec.pago_recibido
              ELSE NULL::double precision
          END, (0)::double precision))) + sum(COALESCE(
          CASE date_part('month'::text, rec.fecha_pago)
              WHEN 4 THEN rec.pago_recibido
              ELSE NULL::double precision
          END, (0)::double precision))) + sum(COALESCE(
          CASE date_part('month'::text, rec.fecha_pago)
              WHEN 5 THEN rec.pago_recibido
              ELSE NULL::double precision
          END, (0)::double precision))) + sum(COALESCE(
          CASE date_part('month'::text, rec.fecha_pago)
              WHEN 6 THEN rec.pago_recibido
              ELSE NULL::double precision
          END, (0)::double precision))) + sum(COALESCE(
          CASE date_part('month'::text, rec.fecha_pago)
              WHEN 7 THEN rec.pago_recibido
              ELSE NULL::double precision
          END, (0)::double precision))) + sum(COALESCE(
          CASE date_part('month'::text, rec.fecha_pago)
              WHEN 8 THEN rec.pago_recibido
              ELSE NULL::double precision
          END, (0)::double precision))) + sum(COALESCE(
          CASE date_part('month'::text, rec.fecha_pago)
              WHEN 9 THEN rec.pago_recibido
              ELSE NULL::double precision
          END, (0)::double precision))) + sum(COALESCE(
          CASE date_part('month'::text, rec.fecha_pago)
              WHEN 10 THEN rec.pago_recibido
              ELSE NULL::double precision
          END, (0)::double precision))) + sum(COALESCE(
          CASE date_part('month'::text, rec.fecha_pago)
              WHEN 11 THEN rec.pago_recibido
              ELSE NULL::double precision
          END, (0)::double precision))) + sum(COALESCE(
          CASE date_part('month'::text, rec.fecha_pago)
              WHEN 12 THEN rec.pago_recibido
              ELSE NULL::double precision
          END, (0)::double precision))) AS total
      FROM (((((t_presupuestos p
        JOIN t_tarifa_servicio_groups tsg ON ((tsg.t_presupuesto_id = p.id)))
        JOIN t_tarifa_servicios ts ON ((ts.t_tarifa_servicio_group_id = tsg.id)))
        JOIN t_factura_detalles fd ON ((fd.t_tarifa_servicio_id = ts.id)))
        JOIN t_facturas f ON ((fd.t_factura_id = f.id)))
        JOIN t_recibos rec ON ((rec.t_factura_id = f.id)))
    GROUP BY p.id, p.codigo, p.descripcion, (date_part('year'::text, rec.fecha_pago));
    )
  end
end
