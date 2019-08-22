class TRecibo < ApplicationRecord
	belongs_to :t_factura
  belongs_to :t_cliente
  belongs_to :t_periodo
  belongs_to :t_metodo_pago
  belongs_to :user
	belongs_to :t_tipo_pago

  #has_many :t_recibo_detalle
  has_many :t_cajas, dependent: :destroy
  has_many :t_nota_creditos, dependent: :destroy

  has_many :t_estado_cuentums, dependent: :destroy
  has_many :t_clientes, through: :t_estado_cuentum
end
