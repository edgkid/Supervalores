module ApplicationHelper
    
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
