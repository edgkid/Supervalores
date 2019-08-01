class TRecargo < ApplicationRecord

	#has_many :t_recargo_x_cliente
	#has_many :t_cliente, through: :t_recargo_x_cliente

	has_many :t_recargo_x_cliente
	has_many :t_resolucion, through: :t_recargo_x_cliente

end
