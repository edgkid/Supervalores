class CreateTTipoCuenta < ActiveRecord::Migration[5.2]
  def change
    create_table :t_tipo_cuenta do |t|
      t.string :descripcion, null:false
      t.integer :estatus,    null:false

      t.timestamps
    end
  end
end
