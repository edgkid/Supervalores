class TCliente < ApplicationRecord

    belongs_to :t_tipo_cliente
    belongs_to :t_tipo_persona
    belongs_to :t_estatu
    #belongs_to :t_catalogo_cuenta_sub
    #belongs_to :t_cuenta_ventum
    belongs_to :user

    has_many :t_resolucions
    has_many :t_recibos
    #has_many :t_emisions
    has_many :t_email_masivos
    has_many :t_nota_creditos

    has_many :t_recargo_x_clientes
	has_many :t_recargos, through: :t_recargo_x_cliente

    has_many :t_estado_cuenta
    has_many :t_recibos, through: :t_estado_cuenta

    has_many :t_estado_cuenta
    has_many :t_facturas, through: :t_estado_cuenta

	has_and_belongs_to_many :t_tarifas

    def es_prospecto?
        return self.prospecto_at == nil
    end
end
