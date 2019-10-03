class TFacturaDatatable < ApplicationDatatable
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format

    @view_columns ||= {
      id: { source: "TFactura.id" },
      codigo: { source: "TCliente.codigo" },
      resolucion: { source: "TResolucion.resolucion_codigo" },
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
        id: record.id,
        codigo: record.t_resolucion.t_cliente.codigo,
        resolucion: record.t_resolucion.resolucion_codigo,
        fecha_notificacion: record.fecha_notificacion,
        fecha_vencimiento: record.fecha_vencimiento,
        recargo: record.recargo,
        total_factura: record.total_factura,
        pendiente_fact: record.pendiente_fact,
        tipo: record.tipo,
        DT_RowId: url_for({
          id: record.id, controller: 't_facturas', action: 'preview', only_path: true
        })
      }
    end
  end

  def get_raw_records
    TFactura.joins(:t_resolucion, { t_resolucion: [:t_cliente] }).where(automatica: false)
  end
end
