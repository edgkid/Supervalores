class TEstatusFac < ApplicationRecord
	has_many :t_facturas, dependent: :destroy
end
