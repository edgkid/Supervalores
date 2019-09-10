class CreateTRols < ActiveRecord::Migration[5.2]
  def change
    create_table :t_rols do |t|
      t.string :nombre
      t.text :descripcion
      t.integer :estatus

      t.timestamps
    end
  end
end
