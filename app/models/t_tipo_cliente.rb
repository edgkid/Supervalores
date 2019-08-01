class TTipoCliente < ApplicationRecord

	belongs_to :t_tarifa
	has_many :t_cliente_padre
	#has_many :t_cliente
	has_many :t_resolucion

	#has_and_belongs_to_many :t_tarifa
end
