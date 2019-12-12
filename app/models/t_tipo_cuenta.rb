# == Schema Information
#
# Table name: t_tipo_cuenta
#
#  id          :bigint           not null, primary key
#  descripcion :string           not null
#  estatus     :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class TTipoCuenta < ApplicationRecord
	has_many :t_catalago_cuentas, dependent: :destroy
end
