class EstadisticaDeCuentasXCobrarDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      codigo_nombre: { source: "EstadisticaDeCuentasXCobrarView.codigo_nombre" },
      total_cantidad: { source: "EstadisticaDeCuentasXCobrarView.total_cantidad" },
      total_monto: { source: "EstadisticaDeCuentasXCobrarView.total_monto" },
      anio: { source: "EstadisticaDeCuentasXCobrarView.anio" },
      anio_cantidad: { source: "EstadisticaDeCuentasXCobrarView.anio_cantidad" },
      anio_monto: { source: "EstadisticaDeCuentasXCobrarView.anio_monto" }
    }
  end

  def data
    records.map do |record|
      {
        codigo_nombre: record.codigo_nombre,
        total_cantidad: record.total_cantidad,
        total_monto: record.total_monto,
        anio: record.anio,
        anio_cantidad: record.anio_cantidad,
        anio_monto: record.anio_monto,
        DT_RowId: url_for({
          id: record.id, controller: 't_tarifa_servicios', action: 'show', only_path: true
        })
      }
    end
  end

  def get_raw_records
    tramites =
      if params[:ztart] && params[:ztart] != '' && params[:end] && params[:end] != ''
        EstadisticaDeCuentasXCobrarView.where('anio BETWEEN ? AND ?', params[:ztart], params[:end])
      elsif params[:year] && params[:year] != ''
        EstadisticaDeCuentasXCobrarView.where('anio = ?', params[:year])
      else
        EstadisticaDeCuentasXCobrarView.all
      end

    return tramites
  end
end
