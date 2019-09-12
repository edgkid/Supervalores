class CreateTPermisoModuloRols < ActiveRecord::Migration[5.2]
  def change
    create_table :t_permiso_modulo_rols do |t|
      t.references :t_permiso, foreign_key: true
      t.references :t_modulo_rol, foreign_key: true

      t.timestamps
    end
  end
end
