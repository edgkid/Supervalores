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
        pago_recibido: record.pago_recibido,
        pago_pendiente: record.pago_pendiente,
        monto_acreditado: record.monto_acreditado,
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
