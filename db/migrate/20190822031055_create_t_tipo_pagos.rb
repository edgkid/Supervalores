class CreateTTipoPagos < ActiveRecord::Migration[5.2]
  def change
    create_table :t_tipo_pagos do |t|
      t.string :forma_pago
      t.string :descripcion
      t.float :minimo
      t.float :maximo

      t.timestamps
    end
  end
end
