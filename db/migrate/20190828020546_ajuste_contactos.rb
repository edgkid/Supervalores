class AjusteContactos < ActiveRecord::Migration[5.2]
  def change    
    add_foreign_key :t_contactos, :t_resolucions
  end
end
