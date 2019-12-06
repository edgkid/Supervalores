# == Schema Information
#
# Table name: t_estado_cuenta_conts
#
#  id                       :bigint           not null, primary key
#  detalle                  :string           not null
#  debito                   :float            not null
#  credito                  :float            not null
#  saldo                    :float            not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  t_estado_cuentum_id      :bigint           not null
#  t_factura_detalle_id     :bigint           not null
#  t_tarifa_servicio_id     :bigint           not null
#  t_catalogo_cuenta_sub_id :bigint           not null
#

class TEstadoCuentaCont < ApplicationRecord
	belongs_to :t_estado_cuentum
  belongs_to :t_factura_detalle
  belongs_to :t_tarifa_servicio
  belongs_to :t_catalogo_cuenta_sub
end
