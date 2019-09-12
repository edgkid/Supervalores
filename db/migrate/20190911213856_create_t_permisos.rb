class CreateTPermisos < ActiveRecord::Migration[5.2]
  def change
    create_table :t_permisos do |t|
      t.string :nombre
      t.integer :estatus

      t.timestamps
    end
  end
end
