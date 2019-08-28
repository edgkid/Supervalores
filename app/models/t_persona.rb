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
  
    validates :num_licencia,
        presence: {
            message: "|El número licencia no puede estar vacía."
        },
        format: {
            message: "|El número licencia solo puede tener Números.",
            with: /([0-9]+)/
        },
        :on => [:create, :update]
    
    validates :nombre,
        presence: {
            message: "|El nombre no puede estar vacía."
        },
        format: {
            message: "|El nombre solo puede tener Letras y espacios.",
            with: /([A-Za-z\s]+)/ 
        },
        :on => [:create, :update]
    
    validates :apellido,
        presence: {
            message: "|El apellido no puede estar vacía."
        },
        format: {
            message: "|El apellido solo puede tener Letras y espacios.",
            with: /([A-Za-z\s]+)/ 
        },
        :on => [:create, :update]
    
    validates :telefono,
        presence: {
            message: "|El teléfono no puede estar vacía."
        },
        :on => [:create, :update]
    
    validates :email,
        presence: {
            message: "|El email no puede estar vacía."
        },
        format: {
            message: "|El email solo puede tener Letras, Números y Guiones(-).",
            with: /.+@.+/  
        },
        :on => [:create, :update]
    
    validates :direccion,
        presence: {
            message: "|La dirección no puede estar vacía."
        },
        format: {
            message: "|La dirección solo puede tener Letras, Números, Guiones(-) y espacios.",
            with: /([A-Za-z0-9\-\s]+)/ 
        },
        :on => [:create, :update]

end
