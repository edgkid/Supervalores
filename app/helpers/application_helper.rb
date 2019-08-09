module ApplicationHelper
  def link_to_add_fields(name, f, association, is_table, **args)
    new_object = f.object.class.reflect_on_association(association).klass.new

    fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end

    #link_to name, "#", onclick: h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
    if is_table
      link_to name, '#', class: args[:class], id: args[:id], style: args[:style], onclick: "var new_id = new Date().getTime();var regexp = new RegExp(\"new_\" + \"#{association}\", \"g\");$(this).parent().parent().before(\"#{escape_javascript(fields)}\".replace(regexp, new_id));", remote: true
    else
      link_to name, '#', class: args[:class], id: args[:id], style: args[:style], onclick: "var new_id = new Date().getTime();var regexp = new RegExp(\"new_\" + \"#{association}\", \"g\");$(this).parent().before(\"#{escape_javascript(fields)}\".replace(regexp, new_id));", remote: true
    end
  end

  def link_to_remove_fields(name, f, is_table, **args)
    # f.hidden_field(:_destroy) + link_to(name, '#', onclick: "remove_fields(this)", remote: true)
    if is_table
      f.hidden_field(:_destroy) +
      link_to(name, '#', class: args[:class],
        onclick: "$(this).prev(\"input[type=hidden]\").val(\"1\");$(this).closest(\".fields\").hide();
                  $(this).closest(\".destroy-service-link\").removeClass('destroy-service-link');
                 ", remote: true)
    else
      f.hidden_field(:_destroy) + link_to(name, '#', class: args[:class], onclick: "$(this).prev(\"input[type=hidden]\").val(\"1\");$(this).closest(\".fields\").hide();", remote: true)
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

  def opciones_de_tarifas
    return TTarifa.where(estatus: 1).order(:nombre).pluck :nombre, :id
  end

  def opciones_de_tipos_de_personas
    return TTipoPersona.where(estatus: 1).order(:descripcion).pluck :descripcion, :id
  end  

  def opciones_de_tipos_de_clientes
    return TTipoCliente.where(estatus: 1).order(:descripcion).pluck :descripcion, :id
  end

  def no_existen_clientes_disponibles
    disponible = TEstatus.find_by(descripcion: "Disponible")
    return TCliente.where(t_estatus: disponible).count == 0
  end

  def opciones_de_clientes
    disponible = TEstatus.find_by(descripcion: "Disponible")
    return TCliente.where(t_estatus: disponible).order(:razon_social).pluck "codigo || ' - ' || razon_social", :id
  end
end
