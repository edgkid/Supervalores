class TPeriodo < ApplicationRecord

	has_many :t_factura
	has_many :t_recibo
	has_many :t_emision
	has_many :t_cliente_tarifa

	has_and_belongs_to_many :tarifa
end
