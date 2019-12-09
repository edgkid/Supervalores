class InformePorTiposDeIngresoDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      t_factura_id: { source: "InformePorTiposDeIngresoView.id" },
      t_recibo_id: { source: "InformePorTiposDeIngresoView.t_recibo_id" },
      fecha_pago: { source: "InformePorTiposDeIngresoView.fecha_pago" },
      codigo: { source: "InformePorTiposDeIngresoView.codigo" },
      cliente: { source: "InformePorTiposDeIngresoView.razon_social" },
      metodo_pago: { source: "InformePorTiposDeIngresoView.forma_pago" },
      estado: { source: "InformePorTiposDeIngresoView.estado" },
      importe: { source: "InformePorTiposDeIngresoView.total_factura" }
    }
  end

  def data
    records.map do |record|
      {
        t_factura_id: record.id,
        t_recibo_id: record.t_recibo_id,
        fecha_pago: record.fecha_pago,
        codigo: record.codigo,
        cliente: record.razon_social,
        metodo_pago: record.forma_pago,
        estado: record.estado,
        importe: record.total_factura.truncate(2),
        DT_RowId: url_with_or_without_parent_resource_for(
          TFactura.find(record.id), TRecibo.find(record.t_recibo_id)
        )
      }
    end
  end

  def get_raw_records
    if params[:day]
      InformePorTiposDeIngresoView.where(fecha_pago: params[:day])
    elsif params[:ztart] && params[:end]
      InformePorTiposDeIngresoView.where('fecha_pago BETWEEN ? AND ?', params[:ztart], params[:end])
    elsif params[:month_year]
      InformePorTiposDeIngresoView.where('fecha_pago BETWEEN ? AND ?',
        params[:month_year], params[:month_year].to_date.at_end_of_month.strftime('%d/%m/%Y'))
    elsif params[:bimonthly]
      InformePorTiposDeIngresoView.where('fecha_pago BETWEEN ? AND ?',
        params[:bimonthly], (params[:bimonthly].to_date + 1.month).at_end_of_month.strftime('%d/%m/%Y'))
    elsif params[:quarterly]
      InformePorTiposDeIngresoView.where('fecha_pago BETWEEN ? AND ?',
        params[:quarterly], (params[:quarterly].to_date + 2.months).at_end_of_month.strftime('%d/%m/%Y'))
    elsif params[:biannual]
      InformePorTiposDeIngresoView.where('fecha_pago BETWEEN ? AND ?',
        params[:biannual], (params[:biannual].to_date + 5.months).at_end_of_month.strftime('%d/%m/%Y'))
    elsif params[:year]
      InformePorTiposDeIngresoView.where('fecha_pago BETWEEN ? AND ?',
        params[:year], params[:year].to_date.at_end_of_year.strftime('%d/%m/%Y'))
    else
      InformePorTiposDeIngresoView.all
    end
  end
end
