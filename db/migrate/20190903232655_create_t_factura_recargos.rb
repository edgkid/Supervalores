class CreateTFacturaRecargos < ActiveRecord::Migration[5.2]
  def change
    create_table :t_factura_recargos do |t|
      t.references :t_factura_automatica, foreign_key: true
      t.references :t_recargo, foreign_key: true

      t.timestamps
    end
  end
end
