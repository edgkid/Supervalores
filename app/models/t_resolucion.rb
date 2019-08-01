class TResolucion < ApplicationRecord

	belongs_to :t_cliente
	belongs_to :t_tipo_cliente

	has_many :t_factura

	has_many :t_recargo_x_cliente
	has_many :t_recargo, through: :t_recargo_x_cliente

	has_many :t_cliente_tarifa
	has_many :t_tarifa, through: :t_cliente_tarifa

end
