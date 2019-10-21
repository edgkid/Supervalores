class TFacturaPagadaDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      id: { source: "TFactura.id" },
      razon_social: { source: "TEmpresa.razon_social | (TPersona.nombre & TPersona.apellido) | TOtro.razon_social" },
      resolucion: { source: "TResolucion.resolucion" },
      fecha_notificacion: { source: "TFactura.fecha_notificacion" },
      fecha_vencimiento: { source: "TFactura.fecha_vencimiento" },
      recargo: { source: "TFactura.recargo" },
      total_factura: { source: "TFactura.total_factura" },
    }
  end

  def data
    records.map do |record|
      pending_payment = record.t_recibos.any? ? record.t_recibos.last.pago_pendiente : record.calculate_pending_payment

      t_empresa = record.t_resolucion.t_cliente.persona.try(:rif)            ? record.t_resolucion.t_cliente.persona : nil
      t_persona = record.t_resolucion.t_cliente.persona.try(:cedula)         ? record.t_resolucion.t_cliente.persona : nil
      t_otro    = record.t_resolucion.t_cliente.persona.try(:identificacion) ? record.t_resolucion.t_cliente.persona : nil

      {
        id: record.id,
        razon_social: t_empresa.try(:razon_social) || t_persona.try(:nombre_completo) || t_otro.try(:razon_social),
        resolucion: record.t_resolucion.resolucion,
        fecha_notificacion: record.fecha_notificacion,
        fecha_vencimiento: record.fecha_vencimiento,
        recargo: record.recargo,
        total_factura: record.total_factura,
        DT_RowId: url_for({
          id: record.id, controller: 't_facturas', action: 'preview', only_path: true
        })
      }
    end
  end

  def get_raw_records
    t_facturas = TFactura.joins(:t_recibos, { t_resolucion: [:t_cliente] }, "
      LEFT JOIN t_empresas ON t_empresas.id = t_clientes.persona_id AND t_clientes.persona_type = 'TEmpresa'
      LEFT JOIN t_personas ON t_personas.id = t_clientes.persona_id AND t_clientes.persona_type = 'TPersona'
      LEFT JOIN t_otros    ON t_otros.id    = t_clientes.persona_id AND t_clientes.persona_type = 'TOtro'
    ").where("t_recibos.pago_pendiente <= 0")

    if params[:from] && params[:from] != '' && params[:to] && params[:to] != ''
      t_facturas.where('t_facturas.fecha_notificacion BETWEEN ? AND ?', params[:from], params[:to])
    elsif params[:from] && params[:from] != ''
      t_facturas.where('t_facturas.fecha_notificacion >= ?', params[:from])
    elsif params[:to] && params[:to] != ''
      t_facturas.where('t_facturas.fecha_notificacion <= ?', params[:to])
    else
      t_facturas
    end
  end
end
