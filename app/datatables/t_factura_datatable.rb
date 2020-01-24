class TFacturaDatatable < ApplicationDatatable
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format

    @view_columns ||= {
      id: { source: "TFactura.id" },
      t_cliente: { source: "razon_social", searchable: false },
      resolucion: { source: "resolucion", searchable: false },
      fecha_notificacion: { source: "TFactura.created_at" },
      fecha_vencimiento: { source: "TFactura.fecha_vencimiento" },
      recargo: { source: "TFactura.recargo" },
      total_factura: { source: "TFactura.total_factura" },
      pendiente_fact: { source: "TFactura.pendiente_total", searchable: false }
    }
  end

  def data
    records.map do |record|
      t_factura = find_t_factura(record.id)
      update_status_to_pending(t_factura) if overdue_invoice?(t_factura) && !paid?(t_factura)
      {
        id: record.id,
        t_cliente: record[:razon_social],
        resolucion: record[:resolucion],
        fecha_notificacion: record.created_at.strftime("%d/%m/%Y"),
        fecha_vencimiento: record.fecha_vencimiento.strftime("%d/%m/%Y"),
        recargo: record.recargo,
        total_factura: record.total_factura.truncate(2),
        pendiente_fact: record.pendiente_total, #TRecibo.find_by(id: record[:t_recibo_id]).try(:pago_pendiente) || record.total_factura.truncate(2),
        DT_RowId: url_for({
          id: record.id, controller: 't_facturas', action: 'preview', only_path: true
        })
      }
    end
  end

  def get_raw_records
    TFactura
      .select("
        t_facturas.id, t_facturas.created_at, res.resolucion resolucion, t_facturas.fecha_notificacion,
        t_facturas.fecha_vencimiento, t_facturas.recargo,
        t_facturas.total_factura, COALESCE(e.razon_social, o.razon_social,
        CONCAT(p.nombre, ' ', p.apellido)) razon_social, MAX(rec.id) t_recibo_id")
      .joins("
        LEFT JOIN t_recibos rec ON rec.t_factura_id = t_facturas.id
        LEFT JOIN t_resolucions res ON res.id = t_facturas.t_resolucion_id
        LEFT JOIN t_clientes c ON c.id = res.t_cliente_id OR c.id = t_facturas.t_cliente_id
        LEFT JOIN t_empresas e ON e.id = c.persona_id AND c.persona_type = 'TEmpresa'
        LEFT JOIN t_personas p ON p.id = c.persona_id AND c.persona_type = 'TPersona'
        LEFT JOIN t_otros    o ON o.id = c.persona_id AND c.persona_type = 'TOtro'
        INNER JOIN t_estatuses est ON t_facturas.t_estatus_id = est.id")
      .where(
        "automatica = ? AND
        (est.descripcion ILIKE 'Facturada' OR
        est.descripcion ILIKE 'Pago Pendiente')",
        (params[:automatica] && params[:automatica] == 'true') ? true : false)
      .group("
        t_facturas.id, res.resolucion, t_facturas.fecha_notificacion, t_facturas.fecha_vencimiento,
        t_facturas.recargo, t_facturas.total_factura,
        COALESCE(e.razon_social, o.razon_social, CONCAT(p.nombre, ' ', p.apellido))
      ")
  end

  private

    def update_status_to_pending(t_factura)
      t_factura.update_attribute(:t_estatus_id, TEstatus.find_by(descripcion: 'Pago Pendiente').id)
    end

    def paid?(t_factura)
      t_factura.t_estatus.descripcion == 'Cancelada' ? true : false
    end

    def overdue_invoice?(t_factura)
      Date.today > t_factura.fecha_vencimiento ? true : false
    end

    def find_t_factura(t_factura_id)
      TFactura.find(t_factura_id)
    end
end
