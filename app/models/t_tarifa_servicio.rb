# == Schema Information
#
# Table name: t_tarifa_servicios
#
#  id               :bigint           not null, primary key
#  codigo           :string           not null
#  descripcion      :string           not null
#  nombre           :string           not null
#  clase            :string           not null
#  precio           :float            not null
#  estatus          :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  tipo             :string
#  t_presupuesto_id :bigint
#

class TTarifaServicio < ApplicationRecord
  require 'csv'
  belongs_to :t_presupuesto
  has_many :t_factura_detalles, dependent: :destroy
  has_many :t_estado_cuenta_conts, dependent: :destroy

  def self.group_by_budget_code(path)
    CSV.foreach(path, headers: true) do |row|
      hash_row = row.to_hash

      hash_row.each do |column, val|
        case column.try(:downcase)
        when 'codigo'
          @codigo = val
        when 'partida presupuestaria'
          @partida = val
          par = [@codigo, @partida] if @codigo && @partida
          p par if par

          case @partida
          when '365.1.2.4.2.60'
            @partida = '365.1.2.4.2.3.60'
          end

          t_tarifa_servicio = TTarifaServicio.find_by(codigo: @codigo) if @codigo
          t_presupuesto = TPresupuesto.find_by(codigo: @partida) if @partida

          if t_presupuesto && t_tarifa_servicio
            # t_tarifa_servicio.update_attribute(:t_presupuesto_id, t_presupuesto.id)
            t_tarifa_servicio.t_presupuesto = t_presupuesto
            t_tarifa_servicio.save!
          end
        end
      end
    end
  end
end
