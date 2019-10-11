class TClienteDatatable < ApplicationDatatable
  
  def data
    records_array = super
    records.each_with_index do |record, i|
      records_array[i].merge!({ 
        t_estatus: record.t_estatus.descripcion, 
        es_prospecto: record.prospecto_at == nil ? "Si" : "No",
      })
    end
    records_array
  end

  def get_raw_records
    TCliente.includes(:persona, :t_estatus).all
  end
end
