class TFacturaRecargo < ApplicationRecord
  belongs_to :t_factura_automatica
  belongs_to :t_recargo
end
