class TCatalogoCuentum < ApplicationRecord

	belongs_to :t_tipo_cuenta
	has_many :t_catalogo_cuenta_subs
end
