class TClienteDatatable < ApplicationDatatable
  def view_columns
    super
    @view_columns.merge!({
      codigo: { source: "TCliente.codigo", cond: :like },
      identificacion: { source: "TCliente.identificacion", searchable: false },
      razon_social: { source: "TCliente.razon_social", searchable: false },
      telefono: { source: "TCliente.telefono", searchable: false },
      email: { source: "TCliente.email", searchable: false },
      es_prospecto: { source: "TCliente.prospecto_at", searchable: false },
      t_estatus: { source: "TEstatus.descripcion" },
      tipo_persona: { source: "TCliente.tipo_persona", searchable: false }
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
