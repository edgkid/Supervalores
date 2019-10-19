class TCajaDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      id: { source: "TRecibo.id" },
      t_cliente: { source: "TCliente.id" },
      t_resolucion: { source: "TResolucion.resolucion" },
      fecha_pago: { source: "TRecibo.fecha_pago" },
      pago_pendiente: { source: "TRecibo.pago_pendiente" },
      pago_recibido: { source: "TRecibo.pago_recibido" },
      user: { source: "User.nombre & User.apellido" }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        t_cliente: record.t_cliente.id,
        t_resolucion: record.t_factura.t_resolucion.resolucion,
        fecha_pago: record.fecha_pago,
        pago_pendiente: record.pago_pendiente,
        pago_recibido: record.pago_recibido,
        user: record.user.nombre_completo,
        DT_RowId: url_for([record.t_factura, record])
      }
    end
  end

  def get_raw_records
    TRecibo.joins(:t_cliente, {t_factura: [:t_resolucion]}, :user)
  end
end
