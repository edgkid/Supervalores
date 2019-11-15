class ComparativaIngresosDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      id: { source: "ComparativaIngresosView.id" },
      fecha_pago: { source: "ComparativaIngresosView.fecha_pago" },
      pago_recibido: { source: "ComparativaIngresosView.pago_recibido" },
      detalle_factura: { source: "ComparativaIngresosView.detalle_factura" },
      nombre_servicio: { source: "ComparativaIngresosView.nombre_servicio" },
      descripcion_servicio: { source: "ComparativaIngresosView.descripcion_servicio" },
      identificacion: { source: "ComparativaIngresosView.identificacion" },
      razon_social: { source: "ComparativaIngresosView.razon_social" },
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        fecha_pago: record.fecha_pago,
        pago_recibido: record.pago_recibido,
        detalle_factura: record.detalle_factura,
        nombre_servicio: record.nombre_servicio,
        descripcion_servicio: record.descripcion_servicio,
        identificacion: record.identificacion,
        razon_social: record.razon_social,
        DT_RowId: url_with_or_without_parent_resource_for(
          TFactura.find(record.t_factura_id), TRecibo.find(record.id))
      }
    end
  end

  def get_raw_records
    ComparativaIngresosView.all
    
    # TRecibo
    #   .select(:id, :fecha_pago, :pago_recibido, "cuenta_desc detalle_factura,
    #     ts.nombre nombre_servicio, ts.descripcion descripcion_servicio,
    #     COALESCE(e.rif, o.identificacion, p.cedula) identificacion,
    #     COALESCE(e.razon_social, o.razon_social, CONCAT(p.nombre, ' ', p.apellido)) razon_social")
    #   .joins("INNER JOIN t_clientes c ON f.t_cliente_id = c.id OR res.t_cliente_id = c.id",
    #     t_factura: {t_factura_detalles: :t_tarifa_servicio})
    #   .left_outer_joins("
    #     LEFT OUTER JOIN t_resolucions res ON f.t_resolucion_id = res.id
    #     LEFT OUTER JOIN t_empresas e ON e.id = c.persona_id AND c.persona_type = 'TEmpresa'
    #     LEFT OUTER JOIN t_personas p ON p.id = c.persona_id AND c.persona_type = 'TPersona'
    #     LEFT OUTER JOIN t_otros    o ON o.id = c.persona_id AND c.persona_type = 'TOtro'")
    #   .where("rec.pago_pendiente <= 0")
  end
end
