class CreateTNotaCreditos < ActiveRecord::Migration[5.2]
  def change
    create_table :t_nota_creditos do |t|
      t.float :monto, null: false
      t.string :detalle, null: false
      t.timestamp :fecha_sistema, null: false

      t.timestamps

      t.belongs_to :t_cliente, foreign_key: true, null: false
      t.belongs_to :t_recibo, foreign_key: true, null: false
      t.belongs_to :t_factura, foreign_key: true, null: false
      t.belongs_to :user, foreign_key: true, null: false

    end
  end
end
