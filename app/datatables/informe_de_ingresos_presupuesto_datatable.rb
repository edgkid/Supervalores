class InformeDeIngresosPresupuestoDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      codigo: { source: "InformeDeIngresosPresupuestoView.codigo" },
      anio_pago: { source: "InformeDeIngresosPresupuestoView.anio_pago" },
      pago_enero: { source: "InformeDeIngresosPresupuestoView.pago_enero" },
      pago_febrero: { source: "InformeDeIngresosPresupuestoView.pago_febrero" },
      pago_marzo: { source: "InformeDeIngresosPresupuestoView.pago_marzo" },
      pago_abril: { source: "InformeDeIngresosPresupuestoView.pago_abril" },
      pago_mayo: { source: "InformeDeIngresosPresupuestoView.pago_mayo" },
      pago_junio: { source: "InformeDeIngresosPresupuestoView.pago_junio" },
      pago_julio: { source: "InformeDeIngresosPresupuestoView.pago_julio" },
      pago_agosto: { source: "InformeDeIngresosPresupuestoView.pago_agosto" },
      pago_septiembre: { source: "InformeDeIngresosPresupuestoView.pago_septiembre" },
      pago_octubre: { source: "InformeDeIngresosPresupuestoView.pago_octubre" },
      pago_noviembre: { source: "InformeDeIngresosPresupuestoView.pago_noviembre" },
      pago_diciembre: { source: "InformeDeIngresosPresupuestoView.pago_diciembre" },
      total: { source: "InformeDeIngresosPresupuestoView.total" },
    }
  end

  def data
    records.map do |record|
      {
        codigo: record.codigo,
        anio_pago: record.anio_pago.to_i,
        pago_enero: record.pago_enero || 0,
        pago_febrero: record.pago_febrero || 0,
        pago_marzo: record.pago_marzo || 0,
        pago_abril: record.pago_abril || 0,
        pago_mayo: record.pago_mayo || 0,
        pago_junio: record.pago_junio || 0,
        pago_julio: record.pago_julio || 0,
        pago_agosto: record.pago_agosto || 0,
        pago_septiembre: record.pago_septiembre || 0,
        pago_octubre: record.pago_octubre || 0,
        pago_noviembre: record.pago_noviembre || 0,
        pago_diciembre: record.pago_diciembre || 0,
        total: record.total
      }
    end
  end

  def get_raw_records
    if !params[:year].blank?
      InformeDeIngresosPresupuestoView.where('anio_pago = ?',
        params[:year].to_date.strftime('%Y'))
    else
      InformeDeIngresosPresupuestoView.all
    end
    # if params[:day]
    #   InformeDeIngresosPresupuestoView
    #     .where('primer_pago = ? OR ultimo_pago = ?', params[:day], params[:day])
    # elsif params[:start] && params[:end]
    #   InformeDeIngresosPresupuestoView
    #     .where('(primer_pago BETWEEN ? AND ?) OR (ultimo_pago BETWEEN ? AND ?)',
    #       params[:start], params[:end], params[:start], params[:end])
    # elsif params[:month_year]
    #   InformeDeIngresosPresupuestoView
    #     .where('(primer_pago BETWEEN ? AND ?) OR (ultimo_pago BETWEEN ? AND ?)',
    #     params[:month_year], params[:month_year].to_date.at_end_of_month.strftime('%d/%m/%Y'),
    #     params[:month_year], params[:month_year].to_date.at_end_of_month.strftime('%d/%m/%Y'))
    # elsif params[:bimonthly]
    #   InformeDeIngresosPresupuestoView
    #     .where('(primer_pago BETWEEN ? AND ?) OR (ultimo_pago BETWEEN ? AND ?)',
    #     params[:bimonthly], (params[:bimonthly].to_date + 1.month).at_end_of_month.strftime('%d/%m/%Y'),
    #     params[:bimonthly], (params[:bimonthly].to_date + 1.month).at_end_of_month.strftime('%d/%m/%Y'))
    # elsif params[:quarterly]
    #   InformeDeIngresosPresupuestoView
    #     .where('(primer_pago BETWEEN ? AND ?) OR (ultimo_pago BETWEEN ? AND ?)',
    #     params[:quarterly], (params[:quarterly].to_date + 2.months).at_end_of_month.strftime('%d/%m/%Y'),
    #     params[:quarterly], (params[:quarterly].to_date + 2.months).at_end_of_month.strftime('%d/%m/%Y'))
    # elsif params[:biannual]
    #   InformeDeIngresosPresupuestoView
    #     .where('(primer_pago BETWEEN ? AND ?) OR (ultimo_pago BETWEEN ? AND ?)',
    #     params[:biannual], (params[:biannual].to_date + 5.months).at_end_of_month.strftime('%d/%m/%Y'),
    #     params[:biannual], (params[:biannual].to_date + 5.months).at_end_of_month.strftime('%d/%m/%Y'))
    # elsif params[:year]
    #   InformeDeIngresosPresupuestoView
    #     .where('(primer_pago BETWEEN ? AND ?) OR (ultimo_pago BETWEEN ? AND ?)',
    #     params[:year], params[:year].to_date.at_end_of_year.strftime('%d/%m/%Y'),
    #     params[:year], params[:year].to_date.at_end_of_year.strftime('%d/%m/%Y'))
    # else
    #   InformeDeIngresosPresupuestoView.all
    # end
  end
end
