class CreateTNotaCreditos < ActiveRecord::Migration[5.2]
  def change
    create_table :t_nota_creditos do |t|
      t.integer :t_cliente_id
      t.integer :t_recibo_id
      t.float :monto
      t.boolean :usada
      t.integer :factura_redimida
      t.string :descripcion

      t.timestamps
    end
  end
end
