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

  validates :razon_social,
    presence: {
      message: "|El razón social no puede estar vacío."
    },
    format: {
      message: "|El razón social solo puede tener Letras, Números, Guiones(-), Puntos(.) y entre 6 y 20 caracteres.",
      with: /([A-Za-z0-9\s\-]+){6,20}/ 
    },
    :on => [:create, :update]

  validates :telefono,
    presence: {
      message: "|El telefono no puede estar vacío."
    },
    format: {
      message: "|El telefono no tiene el formato esperado, +58 414 123 4949.",
      with: /(\+[0-9]{2}\s[0-9]{3}\s[0-9]{3}\s[0-9]{4})/ 
    },
    :on => [:create, :update]

  validates :email,
    presence: {
      message: "|El email no puede estar vacío."
    },
    format: {
      message: "|El email no tiene el formato esperado, ejemplo@dominio.com.",
      with: /.+@.+/ 
    },
    :on => [:create, :update]

end
