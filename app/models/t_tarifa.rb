class TTarifa < ApplicationRecord
	has_one :t_tipo_cliente, dependent: :nullify
	has_many :t_cliente_tarifas, dependent: :destroy
	has_many :t_resolucions, through: :t_cliente_tarifa
	#has_and_belongs_to_many :t_tipo_cliente
	has_and_belongs_to_many :t_periodos
end
