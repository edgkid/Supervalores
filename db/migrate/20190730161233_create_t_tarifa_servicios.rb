class CreateTTarifaServicios < ActiveRecord::Migration[5.2]
  def change
    create_table :t_tarifa_servicios do |t|
      t.string :codigo, null: false
      t.string :descripcion, null: false
      t.string :nombre, null: false
      t.string :clase, null: false
      t.float :precio, null: false
      t.integer :estatus, null: false

      t.timestamps

      t.belongs_to :t_tarifa_servicio_group, foreign_key: true, null: false
      t.belongs_to :t_catalogo_cuenta_sub, foreign_key: true, null: false

    end
  end
end
