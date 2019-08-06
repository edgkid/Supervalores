class TTipoPersona < ApplicationRecord
	
	def estatus_text
		return self.estatus == 0 ? "Inactivo" : "Disponible"
	end
	
end
