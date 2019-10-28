class TClienteDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      codigo: { source: "ViewClient.codigo", cond: :like },
      identificacion: { source: "ViewClient.identificacion" },
      razon_social: { source: "ViewClient.razon_social" },
      telefono: { source: "ViewClient.telefono" },
      email: { source: "ViewClient.email" },
      es_prospecto: { source: "ViewClient.es_prospecto" },
      estatus: { source: "ViewClient.estatus" },
      tipo_persona: { source: "ViewClient.tipo_persona" }
    }
  end
  
  def data
    records.map do |record|
      { 
        codigo: record.codigo,
        identificacion: record.identificacion,
        razon_social: record.razon_social,
        telefono: record.telefono,
        email: record.email,
        es_prospecto: record.es_prospecto,
        estatus: record.estatus, 
        tipo_persona: record.tipo_persona,
        DT_RowId: url_for({
          id: record.id, controller: 't_clientes', action: 'show', only_path: true
        })
      }
    end
  end

  def get_raw_records
    ViewClient.all
  end
end
