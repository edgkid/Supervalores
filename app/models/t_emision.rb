# == Schema Information
#
# Table name: t_emisions
#
#  id                :bigint           not null, primary key
#  fecha_emision     :date             not null
#  valor_circulacion :float            not null
#  tasa              :float            not null
#  monto_pagar       :float            not null
#  estatus           :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  t_periodo_id      :bigint           not null
#  t_tipo_emision_id :bigint           not null
#  user_id           :bigint           not null
#

class TEmision < ApplicationRecord
	#belongs_to :t_cliente
  belongs_to :t_periodo
  belongs_to :t_tipo_emision
  belongs_to :user
  
  # :fecha_emision,
  # :valor_circulacion,
  # :tasa,
  # :monto_pagar,
  # :estatus,
  # :t_periodo_id,
  # :t_tipo_emision_id,
  # :user_id


end
