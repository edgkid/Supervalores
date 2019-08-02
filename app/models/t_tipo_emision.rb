class TTipoEmision < ApplicationRecord
	#has_many :t_cliente
	has_many :t_emisions, dependent: :destroy
end
