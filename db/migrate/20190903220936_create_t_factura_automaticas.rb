class CreateTFacturaAutomaticas < ActiveRecord::Migration[5.2]
  def change
    create_table :t_factura_automaticas do |t|
      t.string :nombre_ciclo_facturacion
      t.date :fecha_inicio
      t.references :t_tipo_cliente, foreign_key: true
      t.references :t_periodo, foreign_key: true

      t.timestamps
    end
  end
end
