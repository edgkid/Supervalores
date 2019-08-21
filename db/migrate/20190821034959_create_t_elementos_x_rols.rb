class CreateTElementosXRols < ActiveRecord::Migration[5.2]
  def change
    create_table :t_elementos_x_rols, id: false do |t|

      t.string :accion, null:false

      t.belongs_to :t_rol, foreign_key: true, null: false
      t.belongs_to :t_elemento, foreign_key: true, null: false
    end
  end
end
