class TOtro < ApplicationRecord
  belongs_to :t_tipo_persona
  has_one :t_cliente, as: :persona

  validates :identificacion,
    presence: {
      message: "|La identificación no puede estar vacía."
    },
    format: {
      message: "|La identificación solo puede tener Letras, Números y Guiones(-).",
      with: /([A-Za-z0-9\-]+)/ 
    },
    uniqueness: {
      message: "|Ya existe un registro con esta identificación, use otra por favor.",
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
    end
  end
end
