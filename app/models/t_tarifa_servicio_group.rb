class TTarifaServicioGroup < ApplicationRecord
	belongs_to :t_presupuesto

	has_many :t_tarifa_servicios, dependent: :destroy
	has_many :t_cuenta_financieras, dependent: :destroy
	has_many :t_presupuestos, through: :t_cuenta_financiera

end
