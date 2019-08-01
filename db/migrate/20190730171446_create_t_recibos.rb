class CreateTRecibos < ActiveRecord::Migration[5.2]
  def change
    create_table :t_recibos do |t|
      t.date :fecha_pago, null: false
      t.string :num_cheque
      t.float :pago_recibido, null: false
      t.float :monto_acreditado, null: false
      t.integer :cuenta_deposito
      t.float :pago_pendiente, null: false
      t.integer :estatus, null: false
      t.string :justificacion
      t.timestamp :fecha_erroneo

      t.timestamps

      t.belongs_to :t_factura, foreign_key: true, null: false
      t.belongs_to :t_cliente, foreign_key: true, null: false
      t.belongs_to :t_periodo, foreign_key: true, null: false
      t.belongs_to :t_metodo_pago, foreign_key: true, null: false
      t.belongs_to :user, foreign_key: true, null: false

    end
  end
end
