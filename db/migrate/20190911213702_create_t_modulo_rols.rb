class CreateTModuloRols < ActiveRecord::Migration[5.2]
  def change
    create_table :t_modulo_rols do |t|
      t.references :t_rol, foreign_key: true
      t.references :t_modulo, foreign_key: true

      t.timestamps
    end
  end
end
