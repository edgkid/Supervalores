# == Schema Information
#
# Table name: t_factura_detalles
#
#  id                   :bigint           not null, primary key
#  cantidad             :integer          not null
#  cuenta_desc          :string           not null
#  precio_unitario      :float            not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  t_factura_id         :bigint           not null
#  t_tarifa_servicio_id :bigint           not null
#

class TFacturaDetalle < ApplicationRecord
	belongs_to :t_factura
  belongs_to :t_tarifa_servicio

  has_many :t_estado_cuenta_conts, dependent: :destroy
end
