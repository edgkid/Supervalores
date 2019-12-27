class EstadoDeCuentaDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      fecha_notificacion: { source: "EstadoDeCuentaView.fecha_notificacion" },
      fecha_vencimiento: { source: "EstadoDeCuentaView.fecha_vencimiento" },
      t_factura_id: { source: "EstadoDeCuentaView.id" },
      t_recibo_id: { source: "EstadoDeCuentaView.t_recibo_id" },
      t_presupuesto: { source: "EstadoDeCuentaView.cuenta"},
      servicio_nombre: { source: "EstadoDeCuentaView.nombre"},
      servicio_descripcion: { source: "EstadoDeCuentaView.descripcion"},
      total_factura: { source: "EstadoDeCuentaView.total_factura" },
      debito: { source: "EstadoDeCuentaView.pago_recibido"},
      credito: { source: "EstadoDeCuentaView.monto_acreditado"},
      saldo: { source: "EstadoDeCuentaView.pago_pendiente"}
    }
  end

  def data
    records.map do |record|
      {
        fecha_notificacion: record.fecha_notificacion,
        fecha_vencimiento: record.fecha_vencimiento,
        t_factura_id: record.id,
        t_recibo_id: record.t_recibo_id,
        t_presupuesto: record[:cuenta],
        servicio_nombre: record[:nombre],
        servicio_descripcion: record[:descripcion],
        total_factura: number_to_balboa(record.total_factura, false),
        debito: number_to_balboa(record[:pago_recibido], false),
        credito: number_to_balboa(record[:monto_acreditado], false),
        saldo: number_to_balboa(record[:pago_pendiente], false),
        DT_RowId: url_for({
          id: record.id, controller: 't_facturas', action: 'preview', only_path: true
        })
      }
    end
  end

  def get_raw_records
    if params[:t_cliente_id].blank?
      EstadoDeCuentaView.all
    else
      EstadoDeCuentaView.where('t_cliente_id = ?', params[:t_cliente_id])
    end
  end
end
