class CreateTClienteTarifas < ActiveRecord::Migration[5.2]
  def change
    create_table :t_cliente_tarifas do |t|
      t.float :monto, null: false
      t.date :fecha, null: false
      t.integer :estatus, null: false

      t.timestamps

      t.belongs_to :t_tarifa, foreign_key: true, null: false
      t.belongs_to :t_resolucion, foreign_key: true, null: false
      t.belongs_to :t_periodo, foreign_key: true, null: false

    end
  end
end
