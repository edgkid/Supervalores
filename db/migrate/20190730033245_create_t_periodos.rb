class CreateTPeriodos < ActiveRecord::Migration[5.2]
  def change
    create_table :t_periodos do |t|
      t.string :descripcion, null: false
      t.integer :rango_dias, null: false
      t.integer :dia_tope, null: false
      t.integer :mes_tope, null: false
      t.string :mes_tope_desc, null: false
      t.integer :estatus, null: false

      t.timestamps
    end
  end
end
