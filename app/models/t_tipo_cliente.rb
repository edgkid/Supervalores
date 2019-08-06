class TTipoCliente < ApplicationRecord
	belongs_to :t_tarifa
	
	has_many :t_cliente	
	#has_and_belongs_to_many :t_tarifa

	def estatus_text
		return self.estatus == 0 ? "Inactivo" : "Disponible"
	end
end
