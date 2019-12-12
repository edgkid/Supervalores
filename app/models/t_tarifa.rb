# == Schema Information
#
# Table name: t_tarifas
#
#  id          :bigint           not null, primary key
#  nombre      :string
#  descripcion :string
#  rango_monto :string
#  recargo     :float
#  estatus     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  monto       :decimal(, )
#

class TTarifa < ApplicationRecord
	has_one :t_tipo_cliente, dependent: :nullify
	has_many :t_cliente_tarifas, dependent: :destroy
	has_many :t_resolucions, through: :t_cliente_tarifa
	#has_and_belongs_to_many :t_tipo_cliente
	has_and_belongs_to_many :t_periodos

  def calculate_total
    self.monto + (self.monto * self.recargo)
  end
end
