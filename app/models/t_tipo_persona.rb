class TTipoPersona < ApplicationRecord
	has_many :t_cliente_padres, dependent: :destroy
end
