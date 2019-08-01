class CreateTMetodoPagos < ActiveRecord::Migration[5.2]
  def change
    create_table :t_metodo_pagos do |t|
      t.string :descripcion, null: false
      t.integer :estatus, null: false

      t.timestamps
    end
  end
end
