class TEstadoCuentum < ApplicationRecord
	belongs_to :t_cliente
  belongs_to :t_factura
  belongs_to :t_recibo
  belongs_to :user

  has_many :t_estado_cuenta_conts, dependent: :destroy
end
