class CreateTLeyendas < ActiveRecord::Migration[5.2]
  def change
    create_table :t_leyendas do |t|
      t.integer :anio
      t.string :descripcion
      t.integer :estatus

      t.timestamps
    end
  end
end
