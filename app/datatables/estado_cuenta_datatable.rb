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
                total_factura: number_to_balboa(factura.total_factura, false),
                pendiente_fact: number_to_balboa(factura.pendiente_fact, false),
                tipo: factura.tipo,
                numero_recibo: recibo.id,
                debito: number_to_balboa(recibo.pago_recibido, false),
                credito: number_to_balboa(recibo.monto_acreditado, false),
                saldo: number_to_balboa(recibo.pago_pendiente, false),
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
              recargo: number_to_balboa(factura.calculate_total_surcharge, false),
              total_factura: number_to_balboa(factura.total_factura, false),
              pendiente_fact: number_to_balboa(factura.pendiente_fact, false),
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
    t_resolucion_id = params[:t_resolucion_id] == nil || params[:t_resolucion_id] == "" ? nil : params[:t_resolucion_id]
    TFactura
      .joins(:t_estatus)
      .includes(t_recibos: :user)
      .left_joins({t_recibos: :user}, {t_resolucion: :t_cliente})
      .where("
        t_resolucions.id = ? AND
        (t_estatuses.descripcion = ? OR
        t_estatuses.descripcion = ? OR
        t_estatuses.descripcion = ?)",
        t_resolucion_id, 'Facturada', 'Pago Pendiente', 'Cancelada')
  end
end
