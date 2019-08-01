class CreateTEmailMasivos < ActiveRecord::Migration[5.2]
  def change
    create_table :t_email_masivos do |t|
    	t.string :email, null: false
    	t.string :detalle_envio, null: false
    	t.timestamp :fecha_ejecucion, null: false

      t.timestamps

      t.belongs_to :t_cliente, foreign_key: true, null: false
      t.belongs_to :t_factura, foreign_key: true, null: false
      t.belongs_to :user, foreign_key: true, null: false

    end
  end
end
