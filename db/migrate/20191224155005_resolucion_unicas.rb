class ResolucionUnicas < ActiveRecord::Migration[5.2]
  def change    
    add_index "t_resolucions", "resolucion", unique: true
  end
end
