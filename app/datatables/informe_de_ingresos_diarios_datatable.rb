class InformeDeIngresosDiariosDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      detalle: { source: "TRecibo.justificacion" },
      monto: { source: "TRecibo.pago_recibido" },
    }
  end

  def data
    records.map do |record|
      {
        detalle: record.justificacion,
        monto: record.pago_recibido,
        DT_RowId: url_with_or_without_parent_resource_for(record.t_factura, record)
      }
    end
  end

  def get_raw_records
    if params[:day]
      TRecibo.where(fecha_pago: params[:day])
    elsif params[:start] && params[:end]
      TRecibo.where('fecha_pago BETWEEN ? AND ?', params[:start], params[:end])
    elsif params[:month_year]
      TRecibo.where('fecha_pago BETWEEN ? AND ?',
        params[:month_year], params[:month_year].to_date.at_end_of_month.strftime('%d/%m/%Y'))
    elsif params[:bimonthly]
      TRecibo.where('fecha_pago BETWEEN ? AND ?',
        params[:bimonthly], (params[:bimonthly].to_date + 1.month).at_end_of_month.strftime('%d/%m/%Y'))
    elsif params[:quarterly]
      TRecibo.where('fecha_pago BETWEEN ? AND ?',
        params[:quarterly], (params[:quarterly].to_date + 2.months).at_end_of_month.strftime('%d/%m/%Y'))
    elsif params[:biannual]
      TRecibo.where('fecha_pago BETWEEN ? AND ?',
        params[:biannual], (params[:biannual].to_date + 5.months).at_end_of_month.strftime('%d/%m/%Y'))
    elsif params[:year]
      TRecibo.where('fecha_pago BETWEEN ? AND ?',
        params[:year], params[:year].to_date.at_end_of_year.strftime('%d/%m/%Y'))
    else
      TRecibo.all
    end
  end
end
