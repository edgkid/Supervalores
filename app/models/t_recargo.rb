class TRecargo < ApplicationRecord
  # belongs_to :t_factura, optional: true
	belongs_to :t_periodo
	
	#has_many :t_recargo_x_cliente
	#has_many :t_cliente, through: :t_recargo_x_cliente
	has_many :t_recargo_x_clientes, dependent: :destroy
	has_many :t_resolucions, through: :t_recargo_x_cliente
  has_many :t_recargo_facturas, dependent: :destroy
  has_many :t_facturas, through: :t_recargo_facturas
end
