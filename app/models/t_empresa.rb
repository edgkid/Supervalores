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
    
    validates :razon_social,
        presence: {
            message: "|La razón social no puede estar vacío."
        },
        format: {
            message: "|La razón social solo puede tener Letras, Números, Guiones(-), Puntos(.), Comas(,) y espacios.",
            with: /([A-Za-z0-9\s\-\.,]+)/ 
        },
        :on => [:create, :update]

    validates :direccion_empresa,
        presence: {
            message: "|La dirección de empresa no puede estar vacía."
        },
        format: {
            message: "|La dirección de empresa solo puede tener Letras, Números, Guiones(-) y espacios.",
            with: /([A-Za-z0-9\-\s]+)/ 
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
end
