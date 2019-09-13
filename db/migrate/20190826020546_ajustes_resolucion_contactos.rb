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
    
    remove_column :t_personas, :num_licencia
    add_column :t_resolucions, :num_licencia, :string
    add_column :t_resolucions, :codigo, :string
  end
end
