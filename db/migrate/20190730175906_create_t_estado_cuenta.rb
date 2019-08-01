class CreateTEstadoCuenta < ActiveRecord::Migration[5.2]
  def change
    create_table :t_estado_cuenta do |t|
      t.float :debito, null: false
      t.float :credito, null: false
      t.float :recargo, null: false
      t.float :saldo, null: false
      t.timestamp :fecha_generacion, null: false
      t.timestamp :fech_vencimiento, null: false
      t.string :tipo, null: false
      t.string :estado, null: false

      t.timestamps

      t.belongs_to :t_cliente, foreign_key: true, null: false
      t.belongs_to :t_factura, foreign_key: true
      t.belongs_to :t_recibo, foreign_key: true
      t.belongs_to :user, foreign_key: true, null: false

    end
  end
end
