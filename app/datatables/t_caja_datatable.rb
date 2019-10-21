class TCajaDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      id: { source: "TRecibo.id" },
      # t_cliente: { source: "TCliente.id" },
      t_cliente: { source: "TEmpresa.razon_social | (TPersona.nombre & TPersona.apellido) | TOtro.razon_social" },
      t_resolucion: { source: "TResolucion.resolucion" },
      fecha_pago: { source: "TRecibo.fecha_pago" },
      pago_pendiente: { source: "TRecibo.pago_pendiente" },
      pago_recibido: { source: "TRecibo.pago_recibido" },
      user: { source: "User.nombre & User.apellido" }
    }
  end

  def data
    records.map do |record|
      t_empresa = record.t_cliente.persona.try(:rif)            ? record.t_cliente.persona : nil
      t_persona = record.t_cliente.persona.try(:cedula)         ? record.t_cliente.persona : nil
      t_otro    = record.t_cliente.persona.try(:identificacion) ? record.t_cliente.persona : nil

      {
        id: record.id,
        t_cliente: t_empresa.try(:razon_social) || t_persona.try(:nombre_completo) || t_otro.try(razon_social),
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
    # t_recibos = TRecibo.joins({ t_cliente: [t_persona: { persona_type: 't_persona' }] }, { t_factura: [:t_resolucion] }, :user)
    # t_recibos = TRecibo.joins(:t_cliente, {t_factura: [:t_resolucion]}, :user)

    t_recibos = TRecibo.joins("
      LEFT JOIN t_clientes ON t_clientes.id = t_recibos.t_cliente_id
      LEFT JOIN t_empresas ON t_empresas.id = t_clientes.persona_id AND t_clientes.persona_type = 'TEmpresa'
      LEFT JOIN t_personas ON t_personas.id = t_clientes.persona_id AND t_clientes.persona_type = 'TPersona'
      LEFT JOIN t_otros    ON t_otros.id    = t_clientes.persona_id AND t_clientes.persona_type = 'TOtro'
    ").joins({ t_factura: :t_resolucion }, :user)

    if params[:from] && params[:from] != '' && params[:to] && params[:to] != ''
      t_recibos.where('fecha_pago BETWEEN ? AND ?', params[:from], params[:to])
    elsif params[:from] && params[:from] != ''
      t_recibos.where('fecha_pago >= ?', params[:from])
    elsif params[:to] && params[:to] != ''
      t_recibos.where('fecha_pago <= ?', params[:to])
    else
      t_recibos
    end
  end
end
