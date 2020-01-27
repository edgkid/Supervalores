class InformeDeRecaudacionDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      factura_id: { source: "InformeDeRecaudacionView.t_factura_id" },
      recibo_id: { source: "InformeDeRecaudacionView.id" },
      razon_social: { source: "InformeDeRecaudacionView.razon_social" },
      res: { source: "InformeDeRecaudacionView.resolucion" },
      identificacion: { source: "InformeDeRecaudacionView.identificacion" },
      fecha_pago: { source: "InformeDeRecaudacionView.fecha_pago" },
      forma_pago: { source: "InformeDeRecaudacionView.forma_pago" },
      pago_recibido: { source: "InformeDeRecaudacionView.pago_recibido" }
    }
  end

  def data
    records.map do |record|
      {
        factura_id: record.t_factura_id,
        recibo_id: record.id,
        razon_social: record.razon_social,
        res: record.resolucion || 'Sin Resolución',
        identificacion: record.identificacion,
        fecha_pago: record.fecha_pago.strftime('%d/%m/%Y'),
        forma_pago: record.forma_pago,
        pago_recibido: number_to_balboa(record.pago_recibido, false),
        DT_RowId: url_with_or_without_parent_resource_for(
          TFactura.find(record.t_factura_id), TRecibo.find(record.id)
        )
      }
    end
  end

  def get_raw_records
    if !params[:day].blank?
      InformeDeRecaudacionView.where(fecha_pago: params[:day])
    elsif !params[:ztart].blank? && !params[:end].blank?
      InformeDeRecaudacionView.where('fecha_pago BETWEEN ? AND ?', params[:ztart], params[:end])
    elsif !params[:month_year].blank?
      InformeDeRecaudacionView.where('fecha_pago BETWEEN ? AND ?',
        params[:month_year], params[:month_year].to_date.at_end_of_month.strftime('%d/%m/%Y'))
    elsif !params[:bimonthly].blank?
      InformeDeRecaudacionView.where('fecha_pago BETWEEN ? AND ?',
        params[:bimonthly], (params[:bimonthly].to_date + 1.month).at_end_of_month.strftime('%d/%m/%Y'))
    elsif !params[:quarterly].blank?
      InformeDeRecaudacionView.where('fecha_pago BETWEEN ? AND ?',
        params[:quarterly], (params[:quarterly].to_date + 2.months).at_end_of_month.strftime('%d/%m/%Y'))
    elsif !params[:biannual].blank?
      InformeDeRecaudacionView.where('fecha_pago BETWEEN ? AND ?',
        params[:biannual], (params[:biannual].to_date + 5.months).at_end_of_month.strftime('%d/%m/%Y'))
    elsif !params[:year].blank?
      InformeDeRecaudacionView.where('fecha_pago BETWEEN ? AND ?',
        params[:year], params[:year].to_date.at_end_of_year.strftime('%d/%m/%Y'))
    else
      InformeDeRecaudacionView.all
    end
  end
end
