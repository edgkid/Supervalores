class TTarifa < ApplicationRecord

	has_many :t_tipo_cliente

	has_many :t_cliente_tarifa
	has_many :t_resolucion, through: :t_cliente_tarifa

	#has_and_belongs_to_many :t_tipo_cliente
	has_and_belongs_to_many :t_periodo
end
