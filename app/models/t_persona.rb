class TPersona < ApplicationRecord

  belongs_to :t_empresa, optional: true
  has_one :t_cliente, as: :persona

  validates :cedula,
      presence: {
          message: "|La cédula no puede estar vacía."
      },
      format: {
          message: "|La cédula solo puede tener Letras, Números y Guiones(-).",
          with: /([A-Za-z0-9\-]+)/ 
      },
      uniqueness: {
        message: "|Ya existe una persona con esta cédula, use otra por favor.",
      },
      :on => [:create, :update]

  validates :nombre,
      presence: {
          message: "|El nombre no puede estar vacío."
      },
      format: {
          message: "|El nombre solo puede tener Letras y espacios.",
          with: /([A-Za-z\s]+)/ 
      },
      :on => [:create, :update]
  
  validates :apellido,
      presence: {
          message: "|El apellido no puede estar vacío."
      },
      format: {
          message: "|El apellido solo puede tener Letras y espacios.",
          with: /([A-Za-z\s]+)/ 
      },
      :on => [:create, :update]

  validate :no_es_prospecto

  def full_name
    "#{self.nombre} #{self.apellido}"
  end

  def no_es_prospecto
    if !t_cliente.es_prospecto
      on_assert_add_error telefono == nil || telefono == '', :telefono, '|El teléfono no puede estar vacío.'
      if email == nil || email == ''
        on_assert_add_error true, :email, '|El email no puede estar vacío.'
      else
        on_assert_add_error (email =~ /.+@.+\..+/) == nil, :email, '|El email no tiene el formato esperado, ejemplo@dominio.com.'
      end
      if direccion == nil || direccion == ''
        on_assert_add_error true, :direccion, "|La dirección no puede estar vacía."
      else
        on_assert_add_error (direccion =~ /([A-Za-z0-9\-\s\.]+)/) == nil, :direccion, "|La dirección solo puede tener Letras, Números, Guiones(-) y espacios."
      end
    end
  end
end
