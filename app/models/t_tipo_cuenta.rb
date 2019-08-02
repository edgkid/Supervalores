class TTipoCuenta < ApplicationRecord
	has_many :t_catalago_cuentas, dependent: :destroy
end
