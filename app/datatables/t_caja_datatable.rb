class TCajaDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      id: { source: "CajaView.id" },
      t_cliente: { source: "CajaView.razon_social" },
      t_resolucion: { source: "CajaView.resolucion" },
      fecha_pago: { source: "CajaView.fecha_pago" },
      pago_pendiente: { source: "CajaView.pago_pendiente" },
      pago_recibido: { source: "CajaView.pago_recibido" },
      user: { source: "CajaView.user_name" }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        t_cliente: record.razon_social,
        t_resolucion: record.resolucion,
        fecha_pago: record.fecha_pago,
        pago_pendiente: number_to_balboa(record.pago_pendiente.truncate(2), false),
        pago_recibido: number_to_balboa(record.pago_recibido.truncate(2), false),
        user: record.user_name,
        DT_RowId: url_for([TFactura.find(record.t_factura_id), TRecibo.find(record.id)])
      }
    end
  end

  def get_raw_records
    if params[:from] && params[:from] != '' && params[:to] && params[:to] != ''
      CajaView.where('fecha_pago BETWEEN ? AND ?', params[:from], params[:to])
    elsif params[:from] && params[:from] != ''
      CajaView.where('fecha_pago >= ?', params[:from])
    elsif params[:to] && params[:to] != ''
      CajaView.where('fecha_pago <= ?', params[:to])
    else
      CajaView.all
    end
  end
end
