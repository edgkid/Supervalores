class CreateTRecargoXClientes < ActiveRecord::Migration[5.2]
  def change
    create_table :t_recargo_x_clientes do |t|
      t.string :monto, null: false
      t.date :fecha, null: false
      t.integer :estatus, null: false

      t.timestamps

      t.belongs_to :t_recargo, foreign_key: true, null: false
      t.belongs_to :t_resolucion, foreign_key: true, null: false

    end
  end
end
