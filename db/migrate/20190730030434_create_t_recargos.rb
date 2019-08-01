class CreateTRecargos < ActiveRecord::Migration[5.2]
  def change
    create_table :t_recargos do |t|
      t.string :descripcion, null: false
      t.float :tasa, null: false
      t.integer :estatus, null: false

      t.timestamps
    end
  end
end
