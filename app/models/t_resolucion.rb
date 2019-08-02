class TResolucion < ApplicationRecord
	belongs_to :t_cliente
	belongs_to :t_tipo_cliente

	has_many :t_facturas, dependent: :destroy
	has_many :t_recargo_x_clientes, dependent: :destroy
	has_many :t_recargos, through: :t_recargo_x_cliente
	has_many :t_cliente_tarifas, dependent: :destroy
	has_many :t_tarifas, through: :t_cliente_tarifa
end
