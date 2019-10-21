class TTramitesDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      created_at: { source: "TCliente.created_at" },
      codigo: { source: "TCliente.codigo" },
      ced_pas_ruc: { source: "TEmpresa.rif | TPersona.cedula | TOtro.identificacion" },
      razon_social: { source: "TEmpresa.razon_social | (TPersona.nombre & TPersona.apellido) | TOtro.razon_social" },
      # telefono: { source: "TEmpresa.telefono | TPersona.telefono | TOtro.telefono" },
      # email: { source: "TEmpresa.email | TPersona.email | TOtro.email" },
      es_prospecto: { source: "TCliente.prospecto_at" },
      t_estatus: { source: "TEstatus.descripcion" }
    }
  end

  def data
    records.map do |record|
      t_empresa = record.persona.try(:rif)            ? record.persona : nil
      t_persona = record.persona.try(:cedula)         ? record.persona : nil
      t_otro    = record.persona.try(:identificacion) ? record.persona : nil

      {
        created_at: record.created_at.strftime('%d/%m/%Y'),
        codigo: record.codigo,
        ced_pas_ruc: t_empresa.rif || t_persona.cedula || t_otro.identificacion,
        razon_social: t_empresa.razon_social || t_persona.try(:nombre_completo) || t_otro.razon_social,
        # telefono: record.persona.telefono,
        # email: record.persona.email,
        es_prospecto: record.prospecto_at.nil? ? 'Sí' : 'No',
        t_estatus: record.t_estatus.descripcion,
        DT_RowId: url_for(record)
      }
    end
  end

  def get_raw_records
    t_clientes = TCliente.joins("
      LEFT JOIN t_empresas ON t_empresas.id = t_clientes.persona_id AND t_clientes.persona_type = 'TEmpresa'
      LEFT JOIN t_personas ON t_personas.id = t_clientes.persona_id AND t_clientes.persona_type = 'TPersona'
      LEFT JOIN t_otros    ON t_otros.id    = t_clientes.persona_id AND t_clientes.persona_type = 'TOtro'
    ").joins(:t_estatus)

    if params[:prospecto] && params[:prospecto] == 'true'
      t_clientes = t_clientes.where('prospecto_at IS NULL');
    elsif params[:prospecto] && params[:prospecto] == 'false'
      t_clientes = t_clientes.where('prospecto_at IS NOT NULL');
    end

    if params[:from] && params[:from] != '' && params[:to] && params[:to] != ''
      t_clientes.where('t_clientes.created_at BETWEEN ? AND ?', params[:from], params[:to])
    elsif params[:from] && params[:from] != ''
      t_clientes.where('t_clientes.created_at >= ?', params[:from])
    elsif params[:to] && params[:to] != ''
      t_clientes.where('t_clientes.created_at <= ?', params[:to])
    else
      t_clientes
    end
  end
end
