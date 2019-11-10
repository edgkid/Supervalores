class InformeDeRecaudacionDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      factura_id: { source: "InformeDeRecaudacionView.factura_id" },
      recibo_id: { source: "InformeDeRecaudacionView.recibo_id" },
      razon_social: { source: "InformeDeRecaudacionView.razon_social" },
      res: { source: "InformeDeRecaudacionView.res" },
      identificacion: { source: "InformeDeRecaudacionView.identificacion" },
      fecha_notificacion: { source: "InformeDeRecaudacionView.fecha_notificacion" },
      forma_pago: { source: "InformeDeRecaudacionView.forma_pago" },
      estado: { source: "InformeDeRecaudacionView.estado"},
      total_factura: { source: "InformeDeRecaudacionView.total_factura" }
    }
  end

  def data
    records.map do |record|
      {
        factura_id: record.factura_id,
        recibo_id: record.recibo_id,
        razon_social: record.razon_social,
        res: record.res,
        identificacion: record.identificacion,
        fecha_notificacion: record.fecha_notificacion.strftime('%d/%m/%Y'),
        forma_pago: record.forma_pago,
        estado: record.estado,
        total_factura: record.total_factura,
        DT_RowId: url_for({
          id: record.factura_id, controller: 't_facturas', action: 'preview', only_path: true
        })
      }
    end
  end

  def get_raw_records
    if params[:day]
      InformeDeRecaudacionView.where(fecha_notificacion: params[:day])
    elsif params[:start] && params[:end]
      InformeDeRecaudacionView.where('fecha_notificacion BETWEEN ? AND ?', params[:start], params[:end])
    elsif params[:month_year]
      InformeDeRecaudacionView.where('fecha_notificacion BETWEEN ? AND ?',
        params[:month_year], params[:month_year].to_date.at_end_of_month.strftime('%d/%m/%Y'))
    elsif params[:bimonthly]
      InformeDeRecaudacionView.where('fecha_notificacion BETWEEN ? AND ?',
        params[:bimonthly], (params[:bimonthly].to_date + 1.month).at_end_of_month.strftime('%d/%m/%Y'))
    elsif params[:quarterly]
      InformeDeRecaudacionView.where('fecha_notificacion BETWEEN ? AND ?',
        params[:quarterly], (params[:quarterly].to_date + 2.months).at_end_of_month.strftime('%d/%m/%Y'))
    elsif params[:biannual]
      InformeDeRecaudacionView.where('fecha_notificacion BETWEEN ? AND ?',
        params[:biannual], (params[:biannual].to_date + 5.months).at_end_of_month.strftime('%d/%m/%Y'))
    elsif params[:year]
      InformeDeRecaudacionView.where('fecha_notificacion BETWEEN ? AND ?',
        params[:year], params[:year].to_date.at_end_of_year.strftime('%d/%m/%Y'))
    else
      InformeDeRecaudacionView.all
    end
  end
end
