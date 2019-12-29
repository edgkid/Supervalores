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
    # t_clientes = TCliente
    #   .select(:id, :codigo, "
    #     COALESCE(e.rif, o.identificacion, p.cedula) ide,
    #     COALESCE(e.razon_social, o.razon_social, CONCAT(p.nombre, ' ', p.apellido)) rs")
    #   .joins("
    #     LEFT OUTER JOIN t_empresas e ON e.id = t_clientes.persona_id AND t_clientes.persona_type = 'TEmpresa'
    #     LEFT OUTER JOIN t_personas p ON p.id = t_clientes.persona_id AND t_clientes.persona_type = 'TPersona'
    #     LEFT OUTER JOIN t_otros    o ON o.id = t_clientes.persona_id AND t_clientes.persona_type = 'TOtro'")

    # debugger

    # t_cliente_id = 
    #   if params[:attribute] == 'select-cliente'
    #     t_clientes.where("
    #       COALESCE(e.razon_social, o.razon_social, CONCAT(p.nombre, ' ', p.apellido)) = ?",
    #       params[:val]).take.id
    #   elsif params[:attribute] == 'select-codigo'
    #     t_clientes.where(codigo: params[:val]).take.id
    #   elsif params[:attribute] == 'select-cedula'
    #     t_clientes.where("COALESCE(e.rif, o.identificacion, p.cedula) = ?",
    #       params[:val]).take.id
    #   end

    # if !t_cliente_id.blank?
    #   EstadoDeCuentaView.where('t_cliente_id = ?', t_cliente_id)
    # else
    #   EstadoDeCuentaView.all
    # end

    if params[:t_cliente_id].blank? && params[:t_cliente_id2].blank?
      EstadoDeCuentaView.all
    elsif !params[:t_cliente_id2].blank?
      EstadoDeCuentaView.where('t_cliente_id = ?', params[:t_cliente_id2])
    elsif !params[:t_cliente_id].blank?
      EstadoDeCuentaView.where('t_cliente_id = ?', params[:t_cliente_id])
    end
  end
end
