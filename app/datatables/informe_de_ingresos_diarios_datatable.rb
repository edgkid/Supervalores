class InformeDeIngresosDiariosDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      id: { source: "InformeDeIngresosDiariosView.id" },
      fecha_notificacion: { source: "InformeDeIngresosDiariosView.fecha_notificacion" },
      fecha_vencimiento: { source: "InformeDeIngresosDiariosView.fecha_vencimiento" },
      fecha_pago: { source: "InformeDeIngresosDiariosView.fecha_pago" },
      identificacion: { source: "InformeDeIngresosDiariosView.identificacion" },
      razon_social: { source: "InformeDeIngresosDiariosView.razon_social" },
      tipo_cliente: { source: "InformeDeIngresosDiariosView.tipo_cliente" },
      detalle: { source: "InformeDeIngresosDiariosView.justificacion" },
      monto: { source: "InformeDeIngresosDiariosView.pago_recibido" },
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        fecha_notificacion: record.fecha_notificacion,
        fecha_vencimiento: record.fecha_vencimiento,
        fecha_pago: record.fecha_pago,
        identificacion: record.identificacion,
        razon_social: record.razon_social,
        tipo_cliente: record.tipo_cliente,
        detalle: record.justificacion,
        monto: record.pago_recibido.truncate(2),
        DT_RowId: url_with_or_without_parent_resource_for(
          TFactura.find(record.t_factura_id), TRecibo.find(record.id)
        )
      }
    end
  end

  def get_raw_records
    if params[:day]
      InformeDeIngresosDiariosView.where(fecha_pago: params[:day])
    elsif params[:ztart] && params[:end]
      InformeDeIngresosDiariosView.where('fecha_pago BETWEEN ? AND ?', params[:ztart], params[:end])
    elsif params[:month_year]
      InformeDeIngresosDiariosView.where('fecha_pago BETWEEN ? AND ?',
        params[:month_year], params[:month_year].to_date.at_end_of_month.strftime('%d/%m/%Y'))
    elsif params[:bimonthly]
      InformeDeIngresosDiariosView.where('fecha_pago BETWEEN ? AND ?',
        params[:bimonthly], (params[:bimonthly].to_date + 1.month).at_end_of_month.strftime('%d/%m/%Y'))
    elsif params[:quarterly]
      InformeDeIngresosDiariosView.where('fecha_pago BETWEEN ? AND ?',
        params[:quarterly], (params[:quarterly].to_date + 2.months).at_end_of_month.strftime('%d/%m/%Y'))
    elsif params[:biannual]
      InformeDeIngresosDiariosView.where('fecha_pago BETWEEN ? AND ?',
        params[:biannual], (params[:biannual].to_date + 5.months).at_end_of_month.strftime('%d/%m/%Y'))
    elsif params[:year]
      InformeDeIngresosDiariosView.where('fecha_pago BETWEEN ? AND ?',
        params[:year], params[:year].to_date.at_end_of_year.strftime('%d/%m/%Y'))
    else
      InformeDeIngresosDiariosView.all
    end
  end
end
