class TEmailMasivo < ApplicationRecord

	belongs_to :t_cliente
    belongs_to :t_factura
    belongs_to :user

end
