# == Schema Information
#
# Table name: t_presupuestos
#
#  id          :bigint           not null, primary key
#  codigo      :string
#  descripcion :string
#  estatus     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class TPresupuesto < ApplicationRecord
	has_many :t_catalogo_cuenta_subs, dependent: :destroy
	has_many :t_tarifa_servicio_groups, dependent: :destroy
	has_many :t_cuenta_financieras, dependent: :destroy
	has_many :t_tarifa_servicio_groups, through: :t_cuenta_financiera
end
