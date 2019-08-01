class TCuentaFinanciera < ApplicationRecord

	belongs_to :t_tarifa_servicio_group
	belongs_to :t_presupuesto

end
