# == Schema Information
#
# Table name: t_factura_tarifas
#
#  id                       :bigint           not null, primary key
#  t_conf_fac_automatica_id :bigint
#  t_tarifa_id              :bigint
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class TFacturaTarifa < ApplicationRecord
  belongs_to :t_conf_fac_automatica
  belongs_to :t_tarifa
end
