class TEstatu < ApplicationRecord

	has_many :t_facturas
	has_many :t_clientes

end
