class TClientePadre < ApplicationRecord
	belongs_to :t_tipo_persona
	belongs_to :t_tipo_cliente

	has_many :t_clientes, dependent: :destroy
end
