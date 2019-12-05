# == Schema Information
#
# Table name: t_recargo_x_clientes
#
#  id              :bigint           not null, primary key
#  monto           :string           not null
#  fecha           :date             not null
#  estatus         :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  t_recargo_id    :bigint           not null
#  t_resolucion_id :bigint           not null
#

class TRecargoXCliente < ApplicationRecord
	belongs_to :t_recargo
	belongs_to :t_resolucion
end
