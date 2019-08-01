class CreateTTarifas < ActiveRecord::Migration[5.2]
  def change
    create_table :t_tarifas do |t|
      t.string :nombre
      t.string :descripcion
      t.string :rango_monto
      t.float :recargo
      t.string :estatus

      t.timestamps
    end
  end
end
