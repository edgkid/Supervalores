module ApplicationHelper
    
    def opciones_de_estatus
        return [["Disponible", 1], ["Inactivo", 0]]
    end

    def estatus_text estatus
		return estatus == 0 ? "Inactivo" : "Disponible"
    end

    def opciones_de_tarifas
        return TTarifa.pluck :nombre, :id
    end    
end
