# == Schema Information
#
# Table name: t_cajas
#
#  id            :bigint           not null, primary key
#  pago_recibido :float            not null
#  monto_factura :float            not null
#  vuelto        :float            not null
#  tipo          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  t_recibo_id   :bigint           not null
#  user_id       :bigint           not null
#

class TCaja < ApplicationRecord
	belongs_to :t_recibo
  belongs_to :user
end
