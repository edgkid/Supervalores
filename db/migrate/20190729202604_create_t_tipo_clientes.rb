class CreateTTipoClientes < ActiveRecord::Migration[5.2]
  def change
    create_table :t_tipo_clientes do |t|
      t.string :codigo, null: false
      t.string :descripcion, null: false
      t.string :tipo, null: false
      t.integer :estatus, null: false

      t.timestamps

      t.belongs_to :t_tarifa, foreign_key: true, null: false
    end
  end
end
