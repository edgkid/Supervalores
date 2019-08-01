class CreateTRols < ActiveRecord::Migration[5.2]
  def change
    create_table :t_rols do |t|
      t.string :direccion_url
      t.string :li_class
      t.string :i_class
      t.string :u_class
      t.string :nombre, null: false
      t.string :descripcion, null: false
      t.integer :peso
      t.integer :estatus, null: false
      t.string :icon_class

      t.timestamps
    end
  end
end
