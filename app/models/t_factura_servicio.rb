# == Schema Information
#
# Table name: t_factura_servicios
#
#  id                       :bigint           not null, primary key
#  t_conf_fac_automatica_id :bigint
#  t_tarifa_servicio_id     :bigint
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class TFacturaServicio < ApplicationRecord
  belongs_to :t_conf_fac_automatica
  belongs_to :t_tarifa_servicio
end
