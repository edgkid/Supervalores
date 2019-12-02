class InformeDeIngresosPresupuestoDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      enero: { source: "InformeDeIngresosPresupuestoView.enero" },
      febrero: { source: "InformeDeIngresosPresupuestoView.febrero" },
      marzo: { source: "InformeDeIngresosPresupuestoView.marzo" },
      abril: { source: "InformeDeIngresosPresupuestoView.abril" },
      mayo: { source: "InformeDeIngresosPresupuestoView.mayo" },
      junio: { source: "InformeDeIngresosPresupuestoView.junio" },
      julio: { source: "InformeDeIngresosPresupuestoView.julio" },
      agosto: { source: "InformeDeIngresosPresupuestoView.agosto" },
      septiembre: { source: "InformeDeIngresosPresupuestoView.septiembre" },
      octubre: { source: "InformeDeIngresosPresupuestoView.octubre" },
      noviembre: { source: "InformeDeIngresosPresupuestoView.noviembre" },
      diciembre: { source: "InformeDeIngresosPresupuestoView.diciembre" },
      total: { source: "InformeDeIngresosPresupuestoView.total" },
    }
  end

  def data
    records.map do |record|
      {
        enero: record.enero,
        febrero: record.febrero,
        marzo: record.marzo,
        abril: record.abril,
        mayo: record.mayo,
        junio: record.junio,
        julio: record.julio,
        agosto: record.agosto,
        septiembre: record.septiembre,
        octubre: record.octubre,
        noviembre: record.noviembre,
        diciembre: record.diciembre,
        total: record.total,
        DT_RowId: url_for({
          id: record.t_factura_id, controller: 't_facturas', action: 'preview', only_path: true
        })
      }
    end
  end

  def get_raw_records
    if params[:day]
      InformeDeIngresosPresupuestoView
        .where('primer_pago = ? OR ultimo_pago = ?', params[:day], params[:day])
    elsif params[:start] && params[:end]
      InformeDeIngresosPresupuestoView
        .where('(primer_pago BETWEEN ? AND ?) OR (ultimo_pago BETWEEN ? AND ?)',
          params[:start], params[:end], params[:start], params[:end])
    elsif params[:month_year]
      InformeDeIngresosPresupuestoView
        .where('(primer_pago BETWEEN ? AND ?) OR (ultimo_pago BETWEEN ? AND ?)',
        params[:month_year], params[:month_year].to_date.at_end_of_month.strftime('%d/%m/%Y'),
        params[:month_year], params[:month_year].to_date.at_end_of_month.strftime('%d/%m/%Y'))
    elsif params[:bimonthly]
      InformeDeIngresosPresupuestoView
        .where('(primer_pago BETWEEN ? AND ?) OR (ultimo_pago BETWEEN ? AND ?)',
        params[:bimonthly], (params[:bimonthly].to_date + 1.month).at_end_of_month.strftime('%d/%m/%Y'),
        params[:bimonthly], (params[:bimonthly].to_date + 1.month).at_end_of_month.strftime('%d/%m/%Y'))
    elsif params[:quarterly]
      InformeDeIngresosPresupuestoView
        .where('(primer_pago BETWEEN ? AND ?) OR (ultimo_pago BETWEEN ? AND ?)',
        params[:quarterly], (params[:quarterly].to_date + 2.months).at_end_of_month.strftime('%d/%m/%Y'),
        params[:quarterly], (params[:quarterly].to_date + 2.months).at_end_of_month.strftime('%d/%m/%Y'))
    elsif params[:biannual]
      InformeDeIngresosPresupuestoView
        .where('(primer_pago BETWEEN ? AND ?) OR (ultimo_pago BETWEEN ? AND ?)',
        params[:biannual], (params[:biannual].to_date + 5.months).at_end_of_month.strftime('%d/%m/%Y'),
        params[:biannual], (params[:biannual].to_date + 5.months).at_end_of_month.strftime('%d/%m/%Y'))
    elsif params[:year]
      InformeDeIngresosPresupuestoView
        .where('(primer_pago BETWEEN ? AND ?) OR (ultimo_pago BETWEEN ? AND ?)',
        params[:year], params[:year].to_date.at_end_of_year.strftime('%d/%m/%Y'),
        params[:year], params[:year].to_date.at_end_of_year.strftime('%d/%m/%Y'))
    else
      InformeDeIngresosPresupuestoView.all
    end
  end
end
