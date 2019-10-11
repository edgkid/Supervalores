class TResolucionDatatable < ApplicationDatatable
  
  def data
    records_array = super
    records.each_with_index do |record, i|
      records_array[i].merge!({ 
        t_estatus: record.t_estatus.descripcion,
        t_cliente: record.t_cliente.razon_social,
        created_at: record.created_at.strftime("%d/%m/%Y"),
      })
    end
    records_array
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
