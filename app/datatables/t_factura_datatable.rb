class TFacturaDatatable < ApplicationDatatable
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format

    @view_columns ||= {
      id: { source: "TFactura.id" },
      # codigo: { source: "TCliente.codigo" },
      t_cliente: { source: "TEmpresa.razon_social | (TPersona.nombre & TPersona.apellido) | TOtro.razon_social" },
      resolucion: { source: "TResolucion.resolucion" },
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
      pending_payment = record.t_recibos.any? ? record.t_recibos.last.pago_pendiente : record.calculate_pending_payment
      
      t_empresa = record.t_resolucion.t_cliente.persona.try(:rif)            ? record.t_resolucion.t_cliente.persona : nil
      t_persona = record.t_resolucion.t_cliente.persona.try(:cedula)         ? record.t_resolucion.t_cliente.persona : nil
      t_otro    = record.t_resolucion.t_cliente.persona.try(:identificacion) ? record.t_resolucion.t_cliente.persona : nil

      {
        id: record.id,
        # codigo: record.t_resolucion.t_cliente.codigo,
        t_cliente: t_empresa.try(:razon_social) || t_persona.try(:nombre_completo) || t_otro.try(:razon_social),
        resolucion: record.t_resolucion.resolucion,
        fecha_notificacion: record.fecha_notificacion,
        fecha_vencimiento: record.fecha_vencimiento,
        recargo: record.recargo,
        total_factura: record.total_factura.truncate(2),
        pendiente_fact: pending_payment.truncate(2),
        tipo: record.tipo,
        DT_RowId: url_for({
          id: record.id, controller: 't_facturas', action: 'preview', only_path: true
        })
      }
    end
  end

  def get_raw_records
    # TFactura.joins(:t_resolucion, { t_resolucion: [:t_cliente] }).where(
    #   automatica: (params[:automatica] && params[:automatica] == 'true') ? true : false
    # )

    TFactura.joins("
      LEFT JOIN t_resolucions ON t_resolucions.id = t_facturas.t_resolucion_id
      LEFT JOIN t_clientes    ON t_clientes.id    = t_resolucions.t_cliente_id
      LEFT JOIN t_empresas    ON t_empresas.id    = t_clientes.persona_id
        AND t_clientes.persona_type = 'TEmpresa'
      LEFT JOIN t_personas    ON t_personas.id    = t_clientes.persona_id
        AND t_clientes.persona_type = 'TPersona'
      LEFT JOIN t_otros       ON t_otros.id       = t_clientes.persona_id
        AND t_clientes.persona_type = 'TOtro'
    ").where(
      automatica: (params[:automatica] && params[:automatica] == 'true') ? true : false
    )
  end
end
