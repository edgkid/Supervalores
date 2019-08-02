class TRecibo < ApplicationRecord

	belongs_to :t_factura
  belongs_to :t_cliente
  belongs_to :t_periodo
  belongs_to :t_metodo_pago
  belongs_to :user

  #has_many :t_recibo_detalle
  has_many :t_caja
  has_many :t_nota_credito

  has_many :t_estado_cuentum
  has_many :t_cliente, through: :t_estado_cuentum
    
end
