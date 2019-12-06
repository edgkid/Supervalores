# == Schema Information
#
# Table name: t_factura_recargos
#
#  id                       :bigint           not null, primary key
#  t_conf_fac_automatica_id :bigint
#  t_recargo_id             :bigint
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

# Esta clase la usa el modelo TConfFacAutomatica
class TFacturaRecargo < ApplicationRecord
  belongs_to :t_conf_fac_automatica
  belongs_to :t_recargo
end
