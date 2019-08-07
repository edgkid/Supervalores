class TEstatus < ApplicationRecord	

	has_many :t_facturas
	has_many :t_clientes

	def estatus_text
		return self.estatus == 0 ? "Inactivo" : "Disponible"
	end
	
	def para_text
		return self.para == 0 ? "Todas las entidades" 
			: self.para == 1 ? "Solo Facturas" 
			: self.para == 2 ? "Solo Clientes"
			: "Por definir"
	end
	
end
