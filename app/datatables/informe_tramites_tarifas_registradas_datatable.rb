class InformeTramitesTarifasRegistradasDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {      
      codigo: { source: "InformeTramitesTarifasRegistradasView.id" },,
      nombre: { source: "InformeTramitesTarifasRegistradasView.nombre" },,
      cantidad: { source: "InformeTramitesTarifasRegistradasView.anio_cantidad", searchable: false },,
      monto: { source: "InformeTramitesTarifasRegistradasView.anio_monto" },,
      anio: { source: "InformeTramitesTarifasRegistradasView.anio", searchable: false }
    }
  end

  def data
    records.map do |record|
      {
        codigo: record.id,
        nombre: record.nombre,
        anio_cantidad: record.anio_cantidad.to_f,
        anio_monto: record.anio_monto.to_f,        
        anio: record.anio,
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
