class InformeTramitesTarifasRegistradasDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      codigo: { source: "InformeTramitesTarifasRegistradasView.id" },
      nombre: { source: "InformeTramitesTarifasRegistradasView.nombre" },
      total: { source: "InformeTramitesTarifasRegistradasView.total_cantidad", searchable: false },
      anio: { source: "InformeTramitesTarifasRegistradasView.anio" },
      anio_total: { source: "InformeTramitesTarifasRegistradasView.anio_cantidad", searchable: false }
    }
  end

  def data
    records.map do |record|
      {
        codigo: record.id,
        nombre: record.nombre,
        total: record.total_cantidad,        
        anio: record.anio,
        anio_total: record.anio_cantidad.to_f,
        DT_RowId: url_for({
          id: record.id, controller: 't_tarifa_servicios', action: 'show', only_path: true
        })
      }
    end
  end

  def get_raw_records
    tramites =
      if params[:ztart] && params[:ztart] != '' && params[:end] && params[:end] != ''
        InformeTramitesTarifasRegistradasView.where('anio BETWEEN ? AND ?', params[:ztart], params[:end])
      elsif params[:year] && params[:year] != ''
        InformeTramitesTarifasRegistradasView.where('anio = ?', params[:year])
      else
        InformeTramitesTarifasRegistradasView.all
      end

    return tramites
  end
end
