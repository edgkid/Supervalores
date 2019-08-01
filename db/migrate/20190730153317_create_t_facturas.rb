class CreateTFacturas < ActiveRecord::Migration[5.2]
  def change
    create_table :t_facturas do |t|
      t.date :fecha_notificacion, null: false
      t.date :fecha_vencimiento, null: false
      t.float :recargo, null: false
      t.float :recargo_desc, null: false
      t.float :itbms, null: false
      t.integer :cantidad_total
      t.float :importe_total, null: false
      t.float :total_factura, null: false
      t.float :pendiente_fact, null: false
      t.float :pendiente_ts, null: false
      t.string :tipo, null: false
      t.string :justificacion
      t.timestamp :fecha_erroneo
      t.date :next_fecha_recargo, null: false
      t.float :monto_emision, null: false

      t.timestamps

      #t.belongs_to :t_cliente, foreign_key: true, null: false
      t.belongs_to :t_resolucion, foreign_key: true, null: false
      t.belongs_to :t_periodo, foreign_key: true, null: false
      t.belongs_to :t_estatus_fac, foreign_key: true, null: false
      t.belongs_to :t_leyenda, foreign_key: true
      t.belongs_to :user, foreign_key: true, null: false

    end
  end
end
