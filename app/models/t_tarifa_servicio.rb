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
  belongs_to :t_tarifa_servicio_group
  has_many :t_factura_detalles, dependent: :destroy
  has_many :t_estado_cuenta_conts, dependent: :destroy

  def self.match_code_by_budget_code_from_csv(path)
    #Revisar como se actualiza esto para que use tarifa_servicio_group
    return
    CSV.foreach(path, headers: true) do |row|
      hash_row = row.to_hash

      hash_row.each do |column, val|
        case column.try(:downcase)
        when 'codigo'
          @codigo = val
        when 'partida presupuestaria'
          @partida = val
          par = [@codigo, @partida] if @codigo && @partida
          # p par if par

          case @codigo
          when 'ATA SMV'
            @codigo = 'ATA-SMV'
          end

          # case @partida
          # when '365.1.2.4.2.60'
          #   @partida = '365.1.2.4.2.3.60'
          # when '365.1.2.6.0.01'
          #   @partida = '365.1.2.6.0.3.01'
          #   p [@codigo, @partida]
          # end

          if @partida.match?(/.+\.16$/)
            @partida = '365.1.2.3.1.3.16'
          elsif @partida.match?(/.+\.60$/)
            @partida = '365.1.2.4.2.3.60'
          elsif @partida.match?(/.+\.01$/)
            @partida = '365.1.2.6.0.3.01'
          elsif @partida.match?(/.+\.99$/)
            @partida = '365.1.2.6.0.3.99'
          elsif @partida.match?(/.+\.32$/)
            @partida = '365.1.2.6.0.3.32'
          elsif @partida.match?(/.+\.55$/)
            @partida = '365.1.5.7.1.3.55'
          else
            'Nah'
          end if @partida

          # p [@codigo, @partida] if @partida

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

  def self.match_name_by_budget_code
    TTarifaServicio
      .where("nombre ILIKE '%SPEED JOYEROS Y ARGENTO VIVO%'")
      .update_all(t_presupuesto_id: TPresupuesto.find_by(codigo: '365.1.2.6.0.3.32').id)

    TTarifaServicio
      .where("nombre ILIKE '%FINANCIERO%'")
      .update_all(t_presupuesto_id: TPresupuesto.find_by(codigo: 'FINANCIERO').id)

    TTarifaServicio
      .where("nombre ILIKE '%gobierno central%'")
      .update_all(t_presupuesto_id: TPresupuesto.find_by(codigo: '365.1.5.7.1.3.55').id)
  end
end
