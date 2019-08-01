class TTarifaServicio < ApplicationRecord

	belongs_to :t_tarifa_servicio_group
    belongs_to :t_catalogo_cuenta_sub

    has_many :t_factura_detalle
    has_many :t_estado_cuenta_cont

end
