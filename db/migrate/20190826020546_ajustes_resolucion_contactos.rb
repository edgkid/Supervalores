class AjustesResolucionContactos < ActiveRecord::Migration[5.2]
  def change
    add_column :t_personas, :direccion, :string

    create_table :t_contactos do |t|
      t.string :nombre
      t.string :apellido
      t.string :telefono
      t.string :direccion
      t.string :email
      t.string :empresa
      t.belongs_to :t_resolucion
      t.timestamps
    end

  end
end
