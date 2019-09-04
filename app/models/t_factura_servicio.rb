class TFacturaServicio < ApplicationRecord
  belongs_to :t_factura_automatica
  belongs_to :t_tarifa_servicio
end
