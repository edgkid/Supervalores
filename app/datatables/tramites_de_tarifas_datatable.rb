class TramitesDeTarifasDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      fecha: { source: "fecha_notificacion", searchable: false },
      cantidad: { source: "cantidad", searchable: false },
      codigo: { source: "TramitesTarifaView.codigo" },
      nombre: { source: "TramitesTarifaView.nombre" },
      descripcion: { source: "TramitesTarifaView.descripcion" },
      tipo: { source: "TramitesTarifaView.tipo" }
    }
  end
  
  def data
    records.map do |record|
      { 
        fecha: record[:fecha_notificacion],
        cantidad: record[:cantidad],
        codigo: record.codigo,
        nombre: record.nombre,
        descripcion: record.descripcion,
        tipo: record.tipo,
        DT_RowId: url_for({
          id: record.id, controller: 't_tarifa_servicios', action: 'show', only_path: true
        })
      }
    end
  end

  def get_raw_records
    tramites = TramitesTarifaView.all

    if params[:from] && params[:from] != '' && params[:to] && params[:to] != ''
      tramites
        .select(:id, 'ARRAY_AGG(fecha_notificacion) fecha_notificacion, SUM(cantidad) cantidad, codigo, nombre, descripcion, tipo')
        .where('fecha_notificacion BETWEEN ? AND ?', params[:from], params[:to])
        .group(:id, :codigo, :nombre, :descripcion, :tipo)
    elsif params[:from] && params[:from] != ''
      tramites
        .select(:id, 'ARRAY_AGG(fecha_notificacion) fecha_notificacion, SUM(cantidad) cantidad, codigo, nombre, descripcion, tipo')
        .where('fecha_notificacion >= ?', params[:from])
        .group(:id, :codigo, :nombre, :descripcion, :tipo)
    elsif params[:to] && params[:to] != ''
      tramites
        .select(:id, 'ARRAY_AGG(fecha_notificacion) fecha_notificacion, SUM(cantidad) cantidad, codigo, nombre, descripcion, tipo')
        .where('fecha_notificacion <= ?', params[:to])
        .group(:id, :codigo, :nombre, :descripcion, :tipo)
    else
      tramites
    end

    # if params[:from] && params[:from] != '' && params[:to] && params[:to] != ''
    #   tramites.where('fecha_notificacion BETWEEN ? AND ?', params[:from], params[:to])
    # elsif params[:from] && params[:from] != ''
    #   tramites.where('fecha_notificacion >= ?', params[:from])
    # elsif params[:to] && params[:to] != ''
    #   tramites.where('fecha_notificacion <= ?', params[:to])
    # else
    #   tramites
    # end
  end
end
