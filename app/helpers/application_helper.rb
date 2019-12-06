module ApplicationHelper
  def link_to_add_fields(name, f, association, is_table, **args)
    new_object = f.object.class.reflect_on_association(association).klass.new

    fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end

    #link_to name, "#", onclick: h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
    if is_table
      link_to name, '#', class: args[:class], id: args[:id], style: args[:style], onclick: "var new_id = new Date().getTime();var regexp = new RegExp(\"new_\" + \"#{association}\", \"g\");$(this).parent().parent().before(\"#{escape_javascript(fields)}\".replace(regexp, new_id));$('.select2-dynamic').select2();", remote: true
      # link_to name, '#', class: args[:class], id: args[:id], style: args[:style], onclick: "addFields();", remote: true
    else
      link_to name, '#', class: args[:class], id: args[:id], style: args[:style], onclick: "var new_id = new Date().getTime();var regexp = new RegExp(\"new_\" + \"#{association}\", \"g\");$(this).parent().before(\"#{escape_javascript(fields)}\".replace(regexp, new_id));", remote: true
    end
  end

  def link_to_remove_fields(name, f, is_table, **args)
    # f.hidden_field(:_destroy) + link_to(name, '#', onclick: "remove_fields(this)", remote: true)
    if is_table
      f.hidden_field(:_destroy) +
      link_to(name, '#', class: args[:class], style: args[:style],
        onclick: "$(this).prev(\"input[type=hidden]\").val(\"1\");$(this).closest(\".fields\").hide();
                  $(this).closest(\".destroy-service-link\").removeClass('destroy-service-link');
                 ", remote: true)
    else
      f.hidden_field(:_destroy) + link_to(name, '#', class: args[:class], style: args[:style], onclick: "$(this).prev(\"input[type=hidden]\").val(\"1\");$(this).closest(\".fields\").hide();", remote: true)
    end
  end
    
  def opciones_de_estatus usar_db=false, para=0, incluir_globales=true
      if usar_db
          if incluir_globales
              return TEstatus.where("(para = 0 OR para = #{para}) AND estatus = 1").order(:descripcion).pluck :descripcion, :id
          else
              return TEstatus.where("para = #{para} AND estatus = 1").order(:descripcion).pluck :descripcion, :id
          end
      else
          return [["Disponible", 1], ["Inactivo", 0]]
      end        
  end

  def estatus_text estatus
    return estatus == 0 ? "Inactivo" : "Disponible"
  end

  def object_options(klass, description = 'descripcion')
    klass.pluck(description, 'id')
  end

  def opciones_de_tarifas
    return TTarifa.where(estatus: 1).order(:nombre).pluck :nombre, :id
  end

  def opciones_de_tipos_de_personas
    return TTipoPersona.where(estatus: 1).order(:descripcion).pluck :descripcion, :id
  end  

  def opciones_de_tipos_de_clientes tipo_persona_id = nil
    if tipo_persona_id.to_s == "2"
      return TTipoCliente.where(estatus: 1, id: [9, 10, 11]).order(:descripcion).pluck :descripcion, :id
    end
    return TTipoCliente.where(estatus: 1).order(:descripcion).pluck :descripcion, :id
  end

  def no_existen_clientes_disponibles
    disponible = TEstatus.find_by(descripcion: "Disponible")
    return TCliente.where(t_estatus: disponible).count == 0
  end

  def number_to_balboa(number, with_unit = true)
    if with_unit
      number_to_currency(number, unit: 'B/.')
    else
      number_to_currency(number, unit: '')
    end
  end

  def opciones_de_clientes
    connection = ActiveRecord::Base.connection()
    results = connection.execute("SELECT tcl.id, (CASE WHEN tem.id IS NOT NULL THEN tem.rif || ' - ' || tem.razon_social WHEN tpe.id IS NOT NULL THEN tpe.cedula || ' - ' || tpe.nombre || ', ' || tpe.apellido ELSE COALESCE(tot.identificacion, '') || ' - ' || tot.razon_social END) as razon_social FROM t_clientes tcl LEFT JOIN t_empresas tem ON tcl.persona_type = 'TEmpresa' AND tcl.persona_id = tem.id LEFT JOIN t_personas tpe ON tcl.persona_type = 'TPersona' AND tcl.persona_id = tpe.id LEFT JOIN t_otros tot ON tcl.persona_type = 'TOtro' AND tcl.persona_id = tot.id")
    opciones = []
    for result in results
      opciones.push [result["razon_social"], result["id"]]
    end
    return opciones
  end
  
  def opciones_de_empresas
    connection = ActiveRecord::Base.connection()
    results = connection.execute("SELECT null as id, 'Ninguna' as razon_social UNION ALL (SELECT id, rif ||' - '|| razon_social FROM t_empresas ORDER BY razon_social)")
    opciones = []
    for result in results
      opciones.push [result["razon_social"], result["id"]]
    end
    return opciones
  end

  def opciones_de_tipos_de_valor_para_empresas
    return TEmpresaTipoValor.where(estatus: 1).order(:descripcion).pluck :descripcion, :id
  end

  def opciones_de_sectores_economicos_para_empresas
    return TEmpresaSectorEconomico.where(estatus: 1).order(:descripcion).pluck :descripcion, :id
  end
  
  def opciones_de_tipos_de_emisiones
    return TTipoEmision.where(estatus: 1).order(:descripcion).pluck :descripcion, :id
  end

  def opciones_de_periodos
    return TPeriodo.where(estatus: 1).order(:descripcion).pluck :descripcion, :id
  end

  def translate_months(months)
    months.map do |month|
      case month.capitalize
      when 'January'
        'Enero'
      when 'February'
        'Febrero'
      when 'March'
        'Marzo'
      when 'April'
        'Abril'
      when 'May'
        'Mayo'
      when 'June'
        'Junio'
      when 'July'
        'Julio'
      when 'August'
        'Agosto'
      when 'September'
        'Septiembre'
      when 'October'
        'Octubre'
      when 'November'
        'Noviembre'
      when 'December'
        'Diciembre'
      else
        nil
      end
    end
  end

  def get_list_of_past_months(quantity_of_months)
    months = []

    ((Date.today - quantity_of_months.months)..Date.today).each do |date|
      months << date.strftime('%B')
    end

    months.uniq
  end
end
