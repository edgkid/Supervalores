class TMetodoPago < ApplicationRecord
	has_many :t_recibos, dependent: :destroy
end
