class TFacturaDetalle < ApplicationRecord

	belongs_to :t_factura
    belongs_to :t_tarifa_servicio

    has_many :t_estado_cuenta_cont

end
