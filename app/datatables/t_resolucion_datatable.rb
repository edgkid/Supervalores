class TResolucionDatatable < ApplicationDatatable

  def view_columns    
    @view_columns ||= {
      t_cliente: { source: "ViewResolution.cliente_razon_social" },
      resolucion: { source: "ViewResolution.resolucion" },
      descripcion: { source: "ViewResolution.resolucion_descripcion" },
      created_at: { source: "ViewResolution.resolucion_created_at" },
      t_estatus: { source: "ViewResolution.estatus_descripcion" }
    }
  end

  def data
    records.map do |record|
      {
        t_cliente: record.cliente_razon_social,
        resolucion: record.resolucion,
        descripcion: record.resolucion_descripcion,
        created_at: record.resolucion_created_at.strftime("%d/%m/%Y"),
        t_estatus: record.estatus_descripcion,
        DT_RowId: url_for({
          id: record.t_resolucion_id, controller: 't_resolucions', action: 'show', only_path: true
        })
      }
    end
  end  

  def get_raw_records    
    if params[:cliente]
      return ViewResolution.where(t_cliente_id: params[:cliente])
    else
      return ViewResolution.all
    end
  end
end
