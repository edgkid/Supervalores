class TPeriodo < ApplicationRecord
	has_many :t_facturas, dependent: :destroy
	has_many :t_recibos, dependent: :destroy
	has_many :t_emisions, dependent: :destroy
	has_many :t_cliente_tarifas, dependent: :destroy

	has_and_belongs_to_many :tarifas
end
