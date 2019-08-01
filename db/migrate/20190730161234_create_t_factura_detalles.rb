class CreateTFacturaDetalles < ActiveRecord::Migration[5.2]
  def change
    create_table :t_factura_detalles do |t|
      t.integer :cantidad, null: false
      t.string :cuenta_desc, null: false
      t.float :precio_unitario, null: false

      t.timestamps

      t.belongs_to :t_factura, foreign_key: true, null: false
      t.belongs_to :t_tarifa_servicio, foreign_key: true, null: false
      
    end
  end
end
