class TTarifaServicioGroup < ApplicationRecord

	belongs_to :t_presupuesto

	has_many :t_tarifa_servicio

	has_many :t_cuenta_financiera
	has_many :t_presupuesto, through: :t_cuenta_financiera

end
