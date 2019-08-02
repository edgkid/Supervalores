class TCliente < ApplicationRecord
	belongs_to :t_cliente_padre
  #belongs_to :t_tipo_cliente
  #belongs_to :t_tipo_emision
  belongs_to :t_catalogo_cuenta_sub
  belongs_to :t_cuenta_ventum
  belongs_to :user

  has_many :t_resolucions, dependent: :destroy
  #has_many :t_factura
  has_many :t_recibos, dependent: :destroy
  #has_many :t_emision
  has_many :t_email_masivos, dependent: :destroy
  has_many :t_nota_creditos, dependent: :destroy

  #has_many :t_recargo_x_cliente
  #has_many :t_recargo, through: :t_recargo_x_cliente

  has_many :t_estado_cuentums, dependent: :destroy
  has_many :t_recibos, through: :t_estado_cuentum

  has_many :t_estado_cuentums, dependent: :destroy
  has_many :t_facturas, through: :t_estado_cuentum

	has_and_belongs_to_many :t_tarifas
end
