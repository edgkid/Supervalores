class TCliente < ApplicationRecord

  belongs_to :t_tipo_cliente
  belongs_to :t_tipo_persona
  belongs_to :t_estatus    

  has_many :t_resolucions
  has_many :t_recibos
  #has_many :t_emisions
  has_many :t_email_masivos
  has_many :t_nota_creditos

  has_many :t_recargo_x_clientes
  has_many :t_recargos, through: :t_recargo_x_cliente

  has_many :t_estado_cuenta
  has_many :t_recibos, through: :t_estado_cuenta
  has_many :t_facturas, through: :t_estado_cuenta

	has_and_belongs_to_many :t_tarifas

  validates :codigo,
    presence: { 
      message: "|El código no puede estar vacío."
    },
    format: { 
      message: "|El código solo puede tener Letras, Números, Guiones(-) y entre 6 y 18 caracteres.",
      with: /([A-Z0-9\-]){6,18}/ 
    },
    :on => [:create, :update]

end
