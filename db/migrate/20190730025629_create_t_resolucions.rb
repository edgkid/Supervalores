class CreateTResolucions < ActiveRecord::Migration[5.2]
  def change
    create_table :t_resolucions do |t|
      t.string :descripcion, null: false
      t.date :fecha_resolucion, null: false

      t.timestamps

      t.belongs_to :t_cliente, foreign_key: true, null: false
      t.belongs_to :t_tipo_cliente, foreign_key: true, null: false
    end
  end
end
