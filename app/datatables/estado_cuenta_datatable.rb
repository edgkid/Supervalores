class EstadoCuentaDatatable < ApplicationDatatable
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format

    @view_columns ||= {
      numero: { source: "TFactura.id" },
      fecha_notificacion: { source: "TFactura.fecha_notificacion" },
      fecha_vencimiento: { source: "TFactura.fecha_vencimiento" },
      recargo: { source: "TFactura.recargo" },
      total_factura: { source: "TFactura.total_factura" },
      pendiente_fact: { source: "TFactura.pendiente_fact" },
      tipo: { source: "TFactura.tipo" }
    }
  end

  def data
    records.map do |record|
      {
        numero: record.id,
        fecha_notificacion: record.fecha_notificacion,
        fecha_vencimiento: record.fecha_vencimiento,
        recargo: record.calculate_total_surcharge,
        total_factura: record.total_factura,
        pendiente_fact: record.calculate_pending_payment,
        tipo: record.tipo,
        DT_RowId: url_for({
          id: record.id, controller: 't_facturas', action: 'preview', only_path: true
        })
      }
    end
  end

  def get_raw_records
    TFactura.where(
      t_estatus_id: params[:t_estatus_id], 
      t_resolucion_id: params[:t_resolucion_id]
    )
  end
end
