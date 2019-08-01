class CreateTCuentaVenta < ActiveRecord::Migration[5.2]
  def change
    create_table :t_cuenta_venta do |t|
      t.string :descripcion
      t.integer :estatus

      t.timestamps
    end
  end
end
