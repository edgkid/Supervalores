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
      message: "|El código solo puede tener Letras, Números y Guiones(-).",
      with: /([A-Za-z0-9\-]+)/ 
    },
    uniqueness: {
      message: "|Ya exista un cliente con este código, use otro por favor.",
    },
    :on => [:create, :update]

  validates :razon_social,
    presence: {
      message: "|El razón social no puede estar vacío."
    },
    format: {
      message: "|El razón social solo puede tener Letras, Números, Guiones(-) y Puntos(.).",
      with: /([A-Za-z0-9\s\-]+)/ 
    },
    :on => [:create, :update]

  validates :telefono,
    presence: {
      message: "|El teléfono no puede estar vacío."
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

  before_save :before_save_record

  def before_save_record
    codigo.upcase!
  end

  attr_accessor :es_prospecto
end
