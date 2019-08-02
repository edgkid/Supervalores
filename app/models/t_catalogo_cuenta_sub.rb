class TCatalogoCuentaSub < ApplicationRecord
	belongs_to :t_catalogo_cuentum
	belongs_to :t_presupuesto

	has_many :t_clientes, dependent: :destroy
	has_many :t_tarifa_servicios, dependent: :destroy
	has_many :t_estado_cuenta_conts, dependent: :destroy
end
