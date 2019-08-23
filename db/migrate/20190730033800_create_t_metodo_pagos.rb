class CreateTMetodoPagos < ActiveRecord::Migration[5.2]
  def change
    create_table :t_metodo_pagos do |t|
      t.string :forma_pago, null: false
      t.string :descripcion, null: false
      t.decimal :minimo
      t.decimal :maximo  
      t.integer :estatus, null: false

      t.timestamps
    end
  end
end
