class EstadoCuentaDatatable < ApplicationDatatable
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format

    @view_columns ||= {
      numero: { source: "TFactura.id" },
      fecha_notificacion: { source: "TFactura.fecha_notificacion" },
      fecha_vencimiento: { source: "TFactura.fecha_vencimiento" },
      recargo: { source: "TFactura.recargo" },
      total_factura: { source: "TFactura.total_factura" },
      pendiente_fact: { source: "TFactura.pendiente_fact" },
      tipo: { source: "TFactura.tipo" },
      numero_recibo: { source: "TRecibo.id"},
      debito: { source: "TRecibo.pago_recibido"},
      credito: { source: "TRecibo.monto_acreditado"},
      saldo: { source: "TRecibo.pago_pendiente"},
      usuario: { source: "User.nombre & User.apellido"}
    }
  end

  def data
    factura_previa = nil
    recibos = []
    records.each do |factura|
      if factura_previa == nil || factura.id != factura_previa.id
        factura_previa = factura
        if factura.t_recibos.size > 0
          factura.t_recibos.each do |recibo|
            recibos.push(
              {
                numero: factura.id,
                fecha_notificacion: factura.fecha_notificacion,
                fecha_vencimiento: factura.fecha_vencimiento,
                recargo: factura.calculate_total_surcharge,
                total_factura: factura.total_factura,
                pendiente_fact: factura.calculate_pending_payment,
                tipo: factura.tipo,
                numero_recibo: recibo.id,
                debito: recibo.pago_recibido,
                credito: recibo.monto_acreditado,
                saldo: recibo.pago_pendiente,
                usuario: recibo.user.nombre_completo,
                DT_RowId: url_for({
                  id: factura.id, controller: 't_facturas', action: 'preview', only_path: true
                })
              }
            )
          end
        else
          recibos.push(
            {
              numero: factura.id,
              fecha_notificacion: factura.fecha_notificacion,
              fecha_vencimiento: factura.fecha_vencimiento,
              recargo: factura.calculate_total_surcharge,
              total_factura: factura.total_factura,
              pendiente_fact: factura.calculate_pending_payment,
              tipo: factura.tipo,
              numero_recibo: 'N/A',
              debito: 'N/A',
              credito: 'N/A',
              saldo: 'N/A',
              usuario: 'N/A',
              DT_RowId: url_for({
                id: factura.id, controller: 't_facturas', action: 'preview', only_path: true
              })
            }
          )
        end
      end
    end
    return recibos
  end

  def get_raw_records
    TFactura.includes(
      {t_recibos: :user}
    )
    .left_joins(
      {t_recibos: :user}, 
      {t_resolucion: :t_cliente}
    )
    .where('t_clientes.codigo = ?', params[:t_cliente_codigo])
  end
end
