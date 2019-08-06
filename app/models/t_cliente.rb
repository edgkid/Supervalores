class TCliente < ApplicationRecord
  belongs_to :t_tipo_cliente
  belongs_to :t_tipo_persona
  belongs_to :t_estatu
  belongs_to :t_catalogo_cuenta_sub
  belongs_to :t_cuenta_ventum
  belongs_to :user

  has_many :t_resolucions
  has_many :t_recibos
  #has_many :t_emision
  has_many :t_email_masivos
  has_many :t_nota_creditos

  has_many :t_recargo_x_clientes
  has_many :t_recargo, through: :t_recargo_x_cliente

  has_many :t_estado_cuentums
  has_many :t_recibo, through: :t_estado_cuentum

  has_many :t_estado_cuentums
  has_many :t_factura, through: :t_estado_cuentum

  has_and_belongs_to_many :t_tarifas
end
