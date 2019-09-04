class CreateTFacturaTarifas < ActiveRecord::Migration[5.2]
  def change
    create_table :t_factura_tarifas do |t|
      t.references :t_factura_automatica, foreign_key: true
      t.references :t_tarifa, foreign_key: true

      t.timestamps
    end
  end
end
