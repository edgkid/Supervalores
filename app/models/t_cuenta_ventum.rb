class TCuentaVentum < ApplicationRecord
	has_many :t_clientes, dependent: :destroy
end
