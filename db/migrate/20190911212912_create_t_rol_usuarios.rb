class CreateTRolUsuarios < ActiveRecord::Migration[5.2]
  def change
    create_table :t_rol_usuarios do |t|
      t.references :user, foreign_key: true
      t.references :t_rol, foreign_key: true

      t.timestamps
    end
  end
end
