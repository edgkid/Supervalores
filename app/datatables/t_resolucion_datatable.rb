class TResolucionDatatable < ApplicationDatatable

  def view_columns    
    @view_columns ||= {
      t_cliente: { source: "TCliente.codigo" },
      resolucion: { source: "TResolucion.resolucion_codigo" },
      descripcion: { source: "TResolucion.descripcion" },
      created_at: { source: "TResolucion.created_at" },
      t_estatus: { source: "TEstatus.descripcion" }
    }
  end

  def data
    records.map do |record|
      {
        t_cliente: record.t_cliente.razon_social,
        resolucion: record.resolucion,
        descripcion: record.descripcion,
        created_at: record.created_at.strftime("%d/%m/%Y"),
        t_estatus: record.t_estatus.descripcion,
        DT_RowId: url_for(record)
      }
    end
  end  

  def get_raw_records
    records = TResolucion.includes({t_cliente: :persona}, :t_estatus)
    if params[:cliente]
      return records.where(t_cliente_id: params[:cliente])
    else
      return records.all
    end
  end
end
