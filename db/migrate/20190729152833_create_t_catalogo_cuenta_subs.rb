class CreateTCatalogoCuentaSubs < ActiveRecord::Migration[5.2]
  def change
    create_table :t_catalogo_cuenta_subs do |t|
      t.string :codigo, null: false
      t.string :descripcion, null: false
      t.integer :estatus, null: false

      t.timestamps

      t.belongs_to :t_catalogo_cuentum, foreign_key: true
      t.belongs_to :t_presupuesto, foreign_key: true, null: false
    end
  end
end
