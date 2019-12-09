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
        total: record.total.truncate(2),
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
