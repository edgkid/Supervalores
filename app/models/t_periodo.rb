# == Schema Information
#
# Table name: t_periodos
#
#  id          :bigint           not null, primary key
#  descripcion :string           not null
#  rango_dias  :integer          not null
#  dia_tope    :integer          not null
#  mes_tope    :integer          not null
#  estatus     :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  tipo        :string
#

class TPeriodo < ApplicationRecord
	has_many :t_facturas, dependent: :destroy
	has_many :t_recibos, dependent: :destroy
	has_many :t_emisions, dependent: :destroy
	has_many :t_cliente_tarifas, dependent: :destroy

	has_and_belongs_to_many :tarifas

  def self.translate_period_type_to_cron(period_type)
    case period_type
      when 'Semanal' then '1w'
      when 'Quincenal' then '2w'
      when 'Mensual' then '1month'
      when 'Bimestral' then '2months'
      when 'Trimestral' then '3months'
      when 'Semestral' then '6months'
      when 'Anual' then '1y'
    end
  end

  def self.translate_period_type_to_days(period_type)
    case period_type
      when 'Semanal' then 7
      when 'Quincenal' then 15
      when 'Mensual' then 30
      when 'Bimestral' then 60
      when 'Trimestral' then 90
      when 'Semestral' then 180
      when 'Anual' then 365
    end
  end
end
