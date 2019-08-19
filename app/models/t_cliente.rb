class TCliente < ApplicationRecord
  belongs_to :persona, polymorphic: true
  belongs_to :t_tipo_cliente  
  belongs_to :t_estatus    

  has_many :t_resolucions, dependent: :destroy
  has_many :t_recibos
  #has_many :t_emisions
  has_many :t_email_masivos
  has_many :t_nota_creditos

  has_many :t_recargo_x_clientes, dependent: :destroy
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
      message: "|Ya existe un cliente con este código, use otro por favor.",
    },
    :on => [:create, :update]

  before_save :before_save_record

  def before_save_record
    codigo.upcase!
  end

  attr_accessor :es_prospecto

  def razon_social
    if persona.is_a?(TPersona)
      return "#{persona.nombre}, #{persona.apellido}"
    elsif persona.is_a?(TEmpresa) || persona.is_a?(TOtro)
      return persona.razon_social
    else
      return "Indeterminado"
    end
  end

  def telefono
    if persona.is_a?(TPersona) || persona.is_a?(TEmpresa) || persona.is_a?(TOtro)
      return persona.telefono
    else
      return "Indeterminado"
    end
  end

  def email
    if persona.is_a?(TPersona) || persona.is_a?(TEmpresa) || persona.is_a?(TOtro)
      return persona.email
    else
      return "Indeterminado"
    end
  end

  def tipo_persona
    if persona.is_a?(TPersona)
      return 2
    elsif persona.is_a?(TEmpresa)
      return 1
    elsif persona.is_a?(TOtro)
      return persona.t_tipo_persona_id
    else
      return "null"
    end
  end
end
