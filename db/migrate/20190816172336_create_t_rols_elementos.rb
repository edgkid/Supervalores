class CreateTRolsElementos < ActiveRecord::Migration[5.2]
  def change
    create_table :t_rols_elementos do |t|

      t.boolean :lee, null: false
      t.boolean :crea, null: false
      t.boolean :edita, null: false
      t.boolean :elimina, null: false

      t.belongs_to :t_rol, foreign_key: true, null: false
      t.belongs_to :elemento, foreign_key: true, null: false
    end
  end
end
