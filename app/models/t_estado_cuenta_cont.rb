class TEstadoCuentaCont < ApplicationRecord
	belongs_to :t_estado_cuentum
  belongs_to :t_factura_detalle
  belongs_to :t_tarifa_servicio
  belongs_to :t_catalogo_cuenta_sub
end
