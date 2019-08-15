class CreateTRolDescs < ActiveRecord::Migration[5.2]
  def change
    create_table :t_rol_descs do |t|
      t.string :id_objeto
      t.string :nombre, null: false
      t.text :pagina
      t.integer :estatus, null: false

      t.timestamps

      t.belongs_to :t_rol, foreign_key: true, null: false
    end
  end
end
