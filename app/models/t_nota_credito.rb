# == Schema Information
#
# Table name: t_nota_creditos
#
#  id             :bigint           not null, primary key
#  t_cliente_id   :integer
#  t_recibo_id    :integer
#  monto          :float
#  t_factura_id   :integer
#  descripcion    :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  monto_original :float
#  status         :string
#

class TNotaCredito < ApplicationRecord
	belongs_to :t_cliente
	belongs_to :t_recibo
	belongs_to :t_factura, optional: true
	
end
