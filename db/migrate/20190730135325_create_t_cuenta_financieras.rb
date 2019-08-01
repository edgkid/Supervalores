class CreateTCuentaFinancieras < ActiveRecord::Migration[5.2]
  def change
    create_table :t_cuenta_financieras do |t|
      t.string :codigo_presupuesto
      t.string :codigo_financiero
      t.string :descripcion_financiera
      t.string :descripcion_presupuestaria

      t.timestamps

      t.belongs_to :t_tarifa_servicio_group, foreign_key: true, null: false
      t.belongs_to :t_presupuesto, foreign_key: true, null: false

    end
  end
end
