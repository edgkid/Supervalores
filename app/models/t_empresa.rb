class TEmpresa < ApplicationRecord
  has_one :t_cliente, as: :persona
  belongs_to :t_empresa_tipo_valor
  belongs_to :t_empresa_sector_economico

  validates :rif,
    presence: {
        message: "|El RIF|RUC no puede estar vacía."
    },
    format: {
        message: "|El RIF|RUC solo puede tener Letras, Números y Guiones(-).",
        with: /([A-Za-z0-9\-]+)/ 
    },
    uniqueness: {
      message: "|Ya existe una empresa con este RIF|RUC, use otro por favor.",
    },
    :on => [:create, :update]
  
  validates :dv,
    presence: { 
    message: "|El dígito verificador no puede estar vacío."
    },
    format: { 
    message: "|El dígito verificador solo puede tener 2 caracteres (Letras o Números).",
    with: /\A([A-Za-z0-9]{2})\z/ 
    },
    :on => [:create, :update]

  validates :razon_social,
    presence: {
        message: "|La razón social no puede estar vacío."
    },
    format: {
        message: "|La razón social solo puede tener Letras, Números, Guiones(-), Puntos(.), Comas(,) y espacios.",
        with: /([A-Za-z0-9\s\-\.,]+)/ 
    },
    :on => [:create, :update]
  
  validate :no_es_prospecto

  def no_es_prospecto
    if !t_cliente.es_prospecto
      on_assert_add_error telefono == nil || telefono == '', :telefono, '|El teléfono no puede estar vacío.'
      if email == nil || email == ''
        on_assert_add_error true, :email, '|El email no puede estar vacío.'
      else
        on_assert_add_error (email =~ /.+@.+\..+/) == nil, :email, '|El email no tiene el formato esperado, ejemplo@dominio.com.'
      end
      if direccion_empresa == nil || direccion_empresa == ''
        on_assert_add_error true, :direccion_empresa, "|La dirección de empresa no puede estar vacía."
      else
        on_assert_add_error (direccion_empresa =~ /([A-Za-z0-9\-\s\.]+)/) == nil, :direccion_empresa, "|La dirección de empresa solo puede tener Letras, Números, Guiones(-), Puntos(.) y espacios."
      end
    end
  end
end
