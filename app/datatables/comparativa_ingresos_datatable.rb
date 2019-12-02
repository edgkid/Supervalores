class ComparativaIngresosDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      id: { source: "ComparativaIngresosView.id" },
      fecha_pago: { source: "ComparativaIngresosView.fecha_pago" },
      detalle_factura: { source: "ComparativaIngresosView.detalle_factura" },
      nombre_servicio: { source: "ComparativaIngresosView.nombre_servicio" },
      descripcion_servicio: { source: "ComparativaIngresosView.descripcion_servicio" },
      identificacion: { source: "ComparativaIngresosView.identificacion" },
      razon_social: { source: "ComparativaIngresosView.razon_social" },
      pago_recibido: { source: "ComparativaIngresosView.pago_recibido" }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        fecha_pago: record.fecha_pago,
        detalle_factura: record.detalle_factura,
        nombre_servicio: record.nombre_servicio,
        descripcion_servicio: record.descripcion_servicio,
        identificacion: record.identificacion,
        razon_social: record.razon_social,
        pago_recibido: record.pago_recibido.truncate(2),
        DT_RowId: url_for(
          # TFactura.find(record.t_factura_id), TRecibo.find(record.id))
          TRecibo.find(record.id).t_factura.try(:t_resolucion).try(:t_cliente) ||
          TRecibo.find(record.id).t_factura.t_cliente
        )
      }
    end
  end

  def get_raw_records
    if !params[:t_cliente_id].blank? && !params[:t_tarifa_servicio_id].blank?
      ComparativaIngresosView.where(
        t_cliente_id: params[:t_cliente_id],
        t_tarifa_servicio_id: params[:t_tarifa_servicio_id]
      )
    elsif !params[:t_cliente_id].blank?
      ComparativaIngresosView.where(t_cliente_id: params[:t_cliente_id])
    elsif !params[:t_tarifa_servicio_id].blank?
      ComparativaIngresosView.where(t_tarifa_servicio_id: params[:t_tarifa_servicio_id])
    else
      ComparativaIngresosView.all
    end
  end
end
