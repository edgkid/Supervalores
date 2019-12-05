# == Schema Information
#
# Table name: t_estado_cuenta
#
#  id               :bigint           not null, primary key
#  debito           :float            not null
#  credito          :float            not null
#  recargo          :float            not null
#  saldo            :float            not null
#  fecha_generacion :datetime         not null
#  fech_vencimiento :datetime         not null
#  tipo             :string           not null
#  estado           :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  t_cliente_id     :bigint           not null
#  t_factura_id     :bigint
#  t_recibo_id      :bigint
#  user_id          :bigint           not null
#

class TEstadoCuentum < ApplicationRecord
	belongs_to :t_cliente
  belongs_to :t_factura
  belongs_to :t_recibo
  belongs_to :user

  has_many :t_estado_cuenta_conts, dependent: :destroy
end
