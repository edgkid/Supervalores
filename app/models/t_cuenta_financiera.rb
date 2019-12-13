# == Schema Information
#
# Table name: t_cuenta_financieras
#
#  id                         :bigint           not null, primary key
#  codigo_presupuesto         :string
#  codigo_financiero          :string
#  descripcion_financiera     :string
#  descripcion_presupuestaria :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  t_tarifa_servicio_group_id :bigint           not null
#  t_presupuesto_id           :bigint           not null
#

class TCuentaFinanciera < ApplicationRecord
	belongs_to :t_tarifa_servicio_group
	belongs_to :t_presupuesto
end
