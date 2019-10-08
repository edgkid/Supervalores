class CreateTRecargoFacturas < ActiveRecord::Migration[5.2]
  def change
    create_table :t_recargo_facturas do |t|
      t.references :t_recargo, foreign_key: true
      t.references :t_factura, foreign_key: true

      t.timestamps
    end
  end
end
