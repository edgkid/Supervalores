class TCatalogoCuentaSub < ApplicationRecord

	belongs_to :t_catalogo_cuentum
	belongs_to :t_presupuesto

	has_many :t_cliente
	has_many :t_tarifa_servicio
	has_many :t_estado_cuenta_cont

end
