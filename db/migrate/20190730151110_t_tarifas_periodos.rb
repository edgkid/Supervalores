class TTarifasPeriodos < ActiveRecord::Migration[5.2]
  def change

  	create_table :t_tarifas_periodos, id: false do |t|

    	t.belongs_to :t_tarifa, foreign_key: true, index: true, null: false
    	t.belongs_to :t_periodo, foreign_key: true, index: true, null: false

    end

  end
end
