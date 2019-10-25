class TClienteDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      codigo: { source: "TCliente.codigo", cond: :like },
      identificacion: { source: "(TEmpresa.rif | TPersona.cedula | TOtro.identificacion)", searchable: false },
      razon_social: { source: "TEmpresa.razon_social | (TPersona.nombre & TPersona.apellido) | TOtro.razon_social" },
      telefono: { source: "TCliente.telefono", searchable: false },
      email: { source: "TCliente.email", searchable: false },
      es_prospecto: { source: "TCliente.prospecto_at", searchable: false },
      t_estatus: { source: "TEstatus.descripcion" },
      tipo_persona: { source: "TCliente.tipo_persona", searchable: false }
    }
  end
  
  def data
    records_array = super
    records.each_with_index do |record, i|
      records_array[i].merge!({ 
        codigo: record.codigo,
        identificacion: record.identificacion,
        razon_social: record.razon_social,
        telefono: record.telefono,
        email: record.email,
        es_prospecto: record.prospecto_at == nil ? "Si" : "No",
        t_estatus: record.t_estatus.descripcion, 
        tipo_persona: record.tipo_persona,
        DT_RowId: url_for(record)
      })
    end
    records_array
  end

  def get_raw_records
    TCliente.includes(:t_estatus).joins(:t_estatus, "
      LEFT JOIN t_empresas ON t_empresas.id = t_clientes.persona_id AND t_clientes.persona_type = 'TEmpresa'
      LEFT JOIN t_personas ON t_personas.id = t_clientes.persona_id AND t_clientes.persona_type = 'TPersona'
      LEFT JOIN t_otros    ON t_otros.id    = t_clientes.persona_id AND t_clientes.persona_type = 'TOtro'
    ")
  end
end
