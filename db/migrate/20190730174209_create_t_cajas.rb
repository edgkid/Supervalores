class CreateTCajas < ActiveRecord::Migration[5.2]
  def change
    create_table :t_cajas do |t|

    	t.float :pago_recibido, null: false
    	t.float :monto_factura, null: false
    	t.float :vuelto, null: false
  		t.string :tipo, null: false

    	t.timestamps

    	t.belongs_to :t_recibo, foreign_key: true, null: false
    	t.belongs_to :user, foreign_key: true, null: false
    end
  end
end
