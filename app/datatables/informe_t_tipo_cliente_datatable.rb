class InformeTTipoClienteDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      tipo_cliente: { source: "InformePorTiposDeClienteView.descripcion" },
      anio_pago: { source: "InformePorTiposDeClienteView.anio_pago" },
      pago_enero: { source: "InformePorTiposDeClienteView.pago_enero" },
      pago_febrero: { source: "InformePorTiposDeClienteView.pago_febrero" },
      pago_marzo: { source: "InformePorTiposDeClienteView.pago_marzo" },
      pago_abril: { source: "InformePorTiposDeClienteView.pago_abril" },
      pago_mayo: { source: "InformePorTiposDeClienteView.pago_mayo" },
      pago_junio: { source: "InformePorTiposDeClienteView.pago_junio" },
      pago_julio: { source: "InformePorTiposDeClienteView.pago_julio" },
      pago_agosto: { source: "InformePorTiposDeClienteView.pago_agosto" },
      pago_septiembre: { source: "InformePorTiposDeClienteView.pago_septiembre" },
      pago_octubre: { source: "InformePorTiposDeClienteView.pago_octubre" },
      pago_noviembre: { source: "InformePorTiposDeClienteView.pago_noviembre" },
      pago_diciembre: { source: "InformePorTiposDeClienteView.pago_diciembre" },
      total: { source: "InformePorTiposDeClienteView.total" }
    }
  end

  def data
    records.map do |record|
      {
        tipo_cliente: record.descripcion,
        anio_pago: record.anio_pago.to_i,
        pago_enero: number_to_balboa(record.pago_enero || 0, false),
        pago_febrero: number_to_balboa(record.pago_febrero || 0, false),
        pago_marzo: number_to_balboa(record.pago_marzo || 0, false),
        pago_abril: number_to_balboa(record.pago_abril || 0, false),
        pago_mayo: number_to_balboa(record.pago_mayo || 0, false),
        pago_junio: number_to_balboa(record.pago_junio || 0, false),
        pago_julio: number_to_balboa(record.pago_julio || 0, false),
        pago_agosto: number_to_balboa(record.pago_agosto || 0, false),
        pago_septiembre: number_to_balboa(record.pago_septiembre || 0, false),
        pago_octubre: number_to_balboa(record.pago_octubre || 0, false),
        pago_noviembre: number_to_balboa(record.pago_noviembre || 0, false),
        pago_diciembre: number_to_balboa(record.pago_diciembre || 0, false),
        total: number_to_balboa(record.total.truncate(2), false),
        DT_RowId: url_for({
          id: record.id, controller: 't_tipo_clientes', action: 'clients_index', only_path: true
        })
      }
    end
  end

  def get_raw_records
    if !params[:year].blank?
      InformePorTiposDeClienteView.where('anio_pago = ?',
        params[:year].to_date.strftime('%Y'))
    else
      InformePorTiposDeClienteView.all
    end
  end
end
