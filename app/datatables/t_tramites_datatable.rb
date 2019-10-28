class TTramitesDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      created_at: { source: "ViewClient.created_at" },
      codigo: { source: "ViewClient.codigo", cond: :like },
      ced_pas_ruc: { source: "ViewClient.identificacion" },
      razon_social: { source: "ViewClient.razon_social" },
      # telefono: { source: "TEmpresa.telefono | TPersona.telefono | TOtro.telefono" },
      # email: { source: "TEmpresa.email | TPersona.email | TOtro.email" },
      es_prospecto: { source: "ViewClient.es_prospecto" },
      t_estatus: { source: "ViewClient.estatus" },
    }
  end

  def data
    records.map do |record|
      {
        created_at: record.created_at.strftime('%d/%m/%Y'),
        codigo: record.codigo,
        ced_pas_ruc: record.identificacion,
        razon_social: record.razon_social,
        # telefono: record.persona.telefono,
        # email: record.persona.email,
        es_prospecto: record.es_prospecto == 'No' ? 'No' : 'Sí',
        t_estatus: record.estatus,
        DT_RowId: url_for({
          id: record.id, controller: 't_clientes', action: 'show', only_path: true
        })
      }
    end
  end

  def get_raw_records
    # t_clientes = TCliente.joins(:t_estatus, "
    #   LEFT JOIN t_empresas ON t_empresas.id = t_clientes.persona_id AND t_clientes.persona_type = 'TEmpresa'
    #   LEFT JOIN t_personas ON t_personas.id = t_clientes.persona_id AND t_clientes.persona_type = 'TPersona'
    #   LEFT JOIN t_otros    ON t_otros.id    = t_clientes.persona_id AND t_clientes.persona_type = 'TOtro'
    # ")

    t_clientes = ViewClient.all

    if params[:prospecto] && params[:prospecto] == 'true'
      t_clientes = t_clientes.where(es_prospecto: 'Si');
    elsif params[:prospecto] && params[:prospecto] == 'false'
      t_clientes = t_clientes.where(es_prospecto: 'No');
    end

    if params[:from] && params[:from] != '' && params[:to] && params[:to] != ''
      t_clientes.where('view_client.created_at BETWEEN ? AND ?', params[:from], params[:to])
    elsif params[:from] && params[:from] != ''
      t_clientes.where('view_client.created_at >= ?', params[:from])
    elsif params[:to] && params[:to] != ''
      t_clientes.where('view_client.created_at <= ?', params[:to])
    else
      t_clientes
    end
  end
end
