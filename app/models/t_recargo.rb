class TRecargo < ApplicationRecord
	#has_many :t_recargo_x_cliente
	#has_many :t_cliente, through: :t_recargo_x_cliente
	has_many :t_recargo_x_clientes, dependent: :destroy
	has_many :t_resolucions, through: :t_recargo_x_cliente
end
