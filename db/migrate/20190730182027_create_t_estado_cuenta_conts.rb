class CreateTEstadoCuentaConts < ActiveRecord::Migration[5.2]
  def change
    create_table :t_estado_cuenta_conts do |t|
      t.string :detalle, null: false
      t.float :debito, null: false
      t.float :credito, null: false
      t.float :saldo, null: false

      t.timestamps

      t.belongs_to :t_estado_cuentum, foreign_key: true, null: false
      t.belongs_to :t_factura_detalle, foreign_key: true, null: false
      t.belongs_to :t_tarifa_servicio, foreign_key: true, null: false
      t.belongs_to :t_catalogo_cuenta_sub, foreign_key: true, null: false

    end
  end
end
