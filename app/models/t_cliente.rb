class TCliente < ApplicationRecord
  belongs_to :persona, polymorphic: true
  # belongs_to :t_tipo_cliente
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
  has_many :t_facturas, dependent: :destroy#, through: :t_estado_cuenta

	has_and_belongs_to_many :t_tarifas

  validate :no_es_prospecto

  def no_es_prospecto
    if !es_prospecto
      on_assert_add_error tipo_persona_id == 1 && (codigo == nil || codigo == ''), :codigo, "|El Código SERI no puede estar vacío."
      on_assert_add_error tipo_persona_id == 1 && (codigo =~ /([A-Za-z0-9\-]+)/) == nil, :codigo, "|El Código SERI solo puede tener Letras, Números y Guiones(-)."
    end
  end

  before_save :before_save_record

  def before_save_record
    codigo.upcase!
  end

  attr_accessor :es_prospecto

  def self.all_clients
    TCliente
      .select(:id, :codigo, "
        COALESCE(e.rif, o.identificacion, p.cedula) ide,
        COALESCE(e.razon_social, o.razon_social, CONCAT(p.nombre, ' ', p.apellido)) rs")
      .joins("
        LEFT OUTER JOIN t_empresas e ON e.id = t_clientes.persona_id AND t_clientes.persona_type = 'TEmpresa'
        LEFT OUTER JOIN t_personas p ON p.id = t_clientes.persona_id AND t_clientes.persona_type = 'TPersona'
        LEFT OUTER JOIN t_otros    o ON o.id = t_clientes.persona_id AND t_clientes.persona_type = 'TOtro'")
  end

  def identificacion
    if persona.is_a?(TPersona)
      return persona.cedula
    elsif persona.is_a?(TEmpresa) 
      return persona.rif
    elsif persona.is_a?(TOtro)
      return persona.identificacion
    else
      return "Indeterminado"
    end
  end
  
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

  def direccion
    if persona.is_a?(TPersona)
      return persona.t_empresa.direccion_empresa
    elsif persona.is_a?(TEmpresa)
      return persona.direccion_empresa
    else
      return "Indeterminado"
    end
  end

  def tipo_persona_id
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
  
  def empresa
    if persona.is_a?(TPersona)
      return persona.t_empresa.razon_social
    elsif persona.is_a?(TEmpresa) || persona.is_a?(TOtro)
      return persona.razon_social
    else
      return "Indeterminado"
    end
  end

  def tipo_persona
    if persona.is_a?(TPersona)
      return "Natural"
    elsif persona.is_a?(TEmpresa)
      return "Jurídica"
    elsif persona.is_a?(TOtro)
      return persona.t_tipo_persona.descripcion
    else
      return "null"
    end
  end

end
