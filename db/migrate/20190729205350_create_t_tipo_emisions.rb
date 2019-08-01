class CreateTTipoEmisions < ActiveRecord::Migration[5.2]
  def change
    create_table :t_tipo_emisions do |t|
      t.string :descripcion
      t.integer :estatus

      t.timestamps
    end
  end
end
