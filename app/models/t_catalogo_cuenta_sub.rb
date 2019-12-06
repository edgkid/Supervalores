# == Schema Information
#
# Table name: t_catalogo_cuenta_subs
#
#  id                    :bigint           not null, primary key
#  codigo                :string           not null
#  descripcion           :string           not null
#  estatus               :integer          not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  t_catalogo_cuentum_id :bigint
#  t_presupuesto_id      :bigint           not null
#

class TCatalogoCuentaSub < ApplicationRecord
	belongs_to :t_catalogo_cuentum
	belongs_to :t_presupuesto

	has_many :t_clientes, dependent: :destroy
	has_many :t_tarifa_servicios, dependent: :destroy
	has_many :t_estado_cuenta_conts, dependent: :destroy
end
