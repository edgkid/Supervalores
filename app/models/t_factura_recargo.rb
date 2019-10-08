# Esta clase la usa el modelo TConfFacAutomatica
class TFacturaRecargo < ApplicationRecord
  belongs_to :t_conf_fac_automatica
  belongs_to :t_recargo
end
