# == Schema Information
#
# Table name: t_cuenta_venta
#
#  id          :bigint           not null, primary key
#  descripcion :string
#  estatus     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class TCuentaVentum < ApplicationRecord
	has_many :t_clientes, dependent: :destroy
end
