# == Schema Information
#
# Table name: t_nota_creditos
#
#  id            :bigint           not null, primary key
#  monto         :float            not null
#  detalle       :string           not null
#  fecha_sistema :datetime         not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  t_cliente_id  :bigint           not null
#  t_recibo_id   :bigint           not null
#  t_factura_id  :bigint           not null
#  user_id       :bigint           not null
#

class TNotaCredito < ApplicationRecord
	belongs_to :t_cliente
  belongs_to :t_recibo
  belongs_to :t_factura
  belongs_to :user
end
