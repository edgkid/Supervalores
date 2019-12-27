class TReciboDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      id: { source: "TRecibosView.id" },
      fecha_pago: { source: "TRecibosView.fecha_pago" },
      forma_pago: { source: "TRecibosView.forma_pago" },
      razon_social: { source: "TRecibosView.razon_social" },
      pago_recibido: { source: "TRecibosView.pago_recibido" },
      pago_pendiente: { source: "TRecibosView.pago_pendiente" },
      monto_acreditado: { source: "TRecibosView.monto_acreditado" },
    }
  end
  
  def data
    records.map do |record|
      { 
        id: record.id,
        fecha_pago: record.fecha_pago,
        forma_pago: record.forma_pago,
        razon_social: record.razon_social,
        pago_recibido: number_to_balboa(record.pago_recibido, false),
        pago_pendiente: number_to_balboa(record.pago_pendiente, false),
        monto_acreditado: number_to_balboa(record.monto_acreditado, false),
        DT_RowId: url_with_or_without_parent_resource_for(
          TFactura.find(record.t_factura_id), TRecibo.find(record.id)
        )
      }
    end
  end

  def get_raw_records
    TRecibosView.all
  end
end
