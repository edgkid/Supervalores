class TPresupuesto < ApplicationRecord

	has_many :t_catalogo_cuenta_sub
	has_many :t_tarifa_servicio_group

	has_many :t_cuenta_financiera
	has_many :t_tarifa_servicio_group, through: :t_cuenta_financiera
end
