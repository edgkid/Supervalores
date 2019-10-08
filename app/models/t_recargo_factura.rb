# Esta clase la usa el modelo TFactura
class TRecargoFactura < ApplicationRecord
  belongs_to :t_recargo
  belongs_to :t_factura
end
