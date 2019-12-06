class TPresupuesto < ApplicationRecord
	has_many :t_catalogo_cuenta_subs, dependent: :destroy
	has_many :t_tarifa_servicio_groups, dependent: :destroy
	has_many :t_cuenta_financieras, dependent: :destroy
	has_many :t_tarifa_servicio_groups, through: :t_cuenta_financiera
  has_many :t_tarifa_servicios

  CODIGOS = %w[
    365.1.2.4.2.60
    365.1.2.6.0.3.99
    365.1.2.6.0.01
  ]
end
