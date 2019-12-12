# == Schema Information
#
# Table name: t_cliente_tarifas
#
#  id              :bigint           not null, primary key
#  monto           :float            not null
#  fecha           :date             not null
#  estatus         :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  t_tarifa_id     :bigint           not null
#  t_resolucion_id :bigint           not null
#  t_periodo_id    :bigint           not null
#

class TClienteTarifa < ApplicationRecord
	belongs_to :t_tarifa
  belongs_to :t_resolucion
  belongs_to :t_periodo
end
