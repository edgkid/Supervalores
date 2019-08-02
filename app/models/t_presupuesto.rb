class TPresupuesto < ApplicationRecord
	has_many :t_catalogo_cuenta_subs, dependent: :destroy
	has_many :t_tarifa_servicio_groups, dependent: :destroy
	has_many :t_cuenta_financieras, dependent: :destroy
	has_many :t_tarifa_servicio_groups, through: :t_cuenta_financiera
end
