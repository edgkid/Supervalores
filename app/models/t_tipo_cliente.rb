class TTipoCliente < ApplicationRecord
	belongs_to :t_tarifa

	has_many :t_cliente_padres, dependent: :destroy
	#has_many :t_cliente
	has_many :t_resolucions, dependent: :destroy
	#has_and_belongs_to_many :t_tarifa
end
