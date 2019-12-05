# == Schema Information
#
# Table name: t_tarifa_servicio_groups
#
#  id               :bigint           not null, primary key
#  nombre           :string           not null
#  estatus          :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  t_presupuesto_id :bigint           not null
#

class TTarifaServicioGroup < ApplicationRecord
	belongs_to :t_presupuesto

	has_many :t_tarifa_servicios, dependent: :destroy
	has_many :t_cuenta_financieras, dependent: :destroy
	has_many :t_presupuestos, through: :t_cuenta_financiera

end
