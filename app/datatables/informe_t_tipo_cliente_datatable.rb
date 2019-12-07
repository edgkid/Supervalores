class InformeTTipoClienteDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      tipo_cliente: { source: "TTipoCliente.descripcion" },
      resolucion: { source: "TResolucion.resolucion" },
      fecha_notificacion: { source: "TFactura.fecha_notificacion" },
      fecha_vencimiento: { source: "TFactura.fecha_vencimiento" },
      recargo: { source: "TFactura.recargo" },
      total_factura: { source: "TFactura.total_factura" }
    }
  end

  def data
    records.map do |record|
      {
        tipo_cliente: record.descripcion,
        resolucion: record.resolucion,
        fecha_notificacion: record.fecha_notificacion,
        fecha_vencimiento: record.fecha_vencimiento,
        recargo: record.recargo,
        total_factura: record.total_factura,
        DT_RowId: url_for({
          id: record.id, controller: 't_tipo_clientes', action: 'clients_index', only_path: true
        })
      }
    end
  end

  def get_raw_records
    t_tipo_clientes = TTipoCliente
      .select('t_tipo_clientes.id, t_tipo_clientes.descripcion,
        t_resolucions.resolucion, t_facturas.fecha_notificacion,
        t_facturas.fecha_vencimiento, t_facturas.recargo, t_facturas.total_factura')
      .joins(t_resolucion: :t_facturas)


    if !params[:day].blank?
      t_tipo_clientes.where('t_facturas.fecha_notificacion = ?', params[:day])
    elsif !params[:start].blank? && !params[:end].blank?
      t_tipo_clientes.where('t_facturas.fecha_notificacion BETWEEN ? AND ?', params[:start], params[:end])
    elsif !params[:month_year].blank?
      t_tipo_clientes.where('t_facturas.fecha_notificacion BETWEEN ? AND ?',
        params[:month_year], params[:month_year].to_date.at_end_of_month.strftime('%d/%m/%Y'))
    elsif !params[:bimonthly].blank?
      t_tipo_clientes.where('t_facturas.fecha_notificacion BETWEEN ? AND ?',
        params[:bimonthly], (params[:bimonthly].to_date + 1.month).at_end_of_month.strftime('%d/%m/%Y'))
    elsif !params[:quarterly].blank?
      t_tipo_clientes.where('t_facturas.fecha_notificacion BETWEEN ? AND ?',
        params[:quarterly], (params[:quarterly].to_date + 2.months).at_end_of_month.strftime('%d/%m/%Y'))
    elsif !params[:biannual].blank?
      t_tipo_clientes.where('t_facturas.fecha_notificacion BETWEEN ? AND ?',
        params[:biannual], (params[:biannual].to_date + 5.months).at_end_of_month.strftime('%d/%m/%Y'))
    elsif !params[:year].blank?
      t_tipo_clientes.where('t_facturas.fecha_notificacion BETWEEN ? AND ?',
        params[:year], params[:year].to_date.at_end_of_year.strftime('%d/%m/%Y'))
    else
      t_tipo_clientes
    end
  end
end
