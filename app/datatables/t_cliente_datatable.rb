class TClienteDatatable < ApplicationDatatable
  def view_columns
    super
    @view_columns.merge!({
      t_estatus: { source: "TEstatus.descripcion" }
    })
  end
  
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
    # TCliente.includes(:persona, :t_estatus).all
    TCliente.includes(:persona).joins(:t_estatus)
  end
end
