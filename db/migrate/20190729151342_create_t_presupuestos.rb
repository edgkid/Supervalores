class CreateTPresupuestos < ActiveRecord::Migration[5.2]
  def change
    create_table :t_presupuestos do |t|
      t.string :codigo
      t.string :descripcion
      t.integer :estatus

      t.timestamps
    end
  end
end
