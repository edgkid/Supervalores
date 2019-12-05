# == Schema Information
#
# Table name: t_email_masivos
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  detalle_envio   :string           not null
#  fecha_ejecucion :datetime         not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  t_cliente_id    :bigint           not null
#  t_factura_id    :bigint           not null
#  user_id         :bigint           not null
#

class TEmailMasivo < ApplicationRecord
	belongs_to :t_cliente
  belongs_to :t_factura
  belongs_to :user
end
