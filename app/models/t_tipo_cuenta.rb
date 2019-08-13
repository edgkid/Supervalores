class TTipoCuenta < ApplicationRecord
	has_many :t_catalago_cuentas, dependent: :destroy

	validates :descripcion , presence: {message: "|La descripción de cuenta no debe estar vacía"}

end
