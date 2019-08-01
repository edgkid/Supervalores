class CreateTTarifaServicioGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :t_tarifa_servicio_groups do |t|
      t.string :nombre, null: false
      t.integer :estatus, null: false

      t.timestamps

      t.belongs_to :t_presupuesto, foreign_key: true, null: false
    end
  end
end
