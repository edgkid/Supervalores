# == Schema Information
#
# Table name: t_nota_creditos
#
#  id               :bigint           not null, primary key
#  t_cliente_id     :integer
#  t_recibo_id      :integer
#  monto            :float
#  usada            :boolean
#  factura_redimida :integer
#  descripcion      :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class TNotaCredito < ApplicationRecord
	belongs_to :t_cliente, optional: true
	has_one :t_recibo
	
end
