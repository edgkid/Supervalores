class CreateTTipoPersonas < ActiveRecord::Migration[5.2]
  def change
    create_table :t_tipo_personas do |t|
      t.string :descripcion
      t.integer :estatus

      t.timestamps
    end
  end
end
