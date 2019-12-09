class InformePresupuestarioDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      codigo: { source: "InformePresupuestarioView.codigo" },
      descripcion: { source: "InformePresupuestarioView.descripcion" },
      pago_pendiente: { source: "pago_pendiente", searchable: false }
    }
  end

  def data
    records.map do |record|
      {
        codigo: record.try(:codigo),
        descripcion: record.try(:descripcion),
        pago_pendiente: record.pago_pendiente.truncate(2)
      }
    end
  end

  def get_raw_records
    t_presupuestos =
      if !params[:day].blank?
        InformePresupuestarioView.where('fecha_notificacion = ?', params[:day])
      elsif !params[:ztart].blank? && !params[:end].blank?
        InformePresupuestarioView.where('fecha_notificacion BETWEEN ? AND ?', params[:ztart], params[:end])
      elsif !params[:month_year].blank?
        InformePresupuestarioView.where('fecha_notificacion BETWEEN ? AND ?',
          params[:month_year], params[:month_year].to_date.at_end_of_month.strftime('%d/%m/%Y'))
      elsif !params[:bimonthly].blank?
        InformePresupuestarioView.where('fecha_notificacion BETWEEN ? AND ?',
          params[:bimonthly], (params[:bimonthly].to_date + 1.month).at_end_of_month.strftime('%d/%m/%Y'))
      elsif !params[:quarterly].blank?
        InformePresupuestarioView.where('fecha_notificacion BETWEEN ? AND ?',
          params[:quarterly], (params[:quarterly].to_date + 2.months).at_end_of_month.strftime('%d/%m/%Y'))
      elsif !params[:biannual].blank?
        InformePresupuestarioView.where('fecha_notificacion BETWEEN ? AND ?',
          params[:biannual], (params[:biannual].to_date + 5.months).at_end_of_month.strftime('%d/%m/%Y'))
      elsif !params[:year].blank?
        InformePresupuestarioView.where('fecha_notificacion BETWEEN ? AND ?',
          params[:year], params[:year].to_date.at_end_of_year.strftime('%d/%m/%Y'))
      else
        InformePresupuestarioView.all
      end
    t_presupuestos
      .select('id, codigo, descripcion, SUM(pago_pendiente) pago_pendiente')
      .group(:id, :codigo, :descripcion)
  end
end
