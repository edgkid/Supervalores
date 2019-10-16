class AcoplandoResolucion < ActiveRecord::Migration[5.2]
  def change    
    remove_column :t_resolucions, :resolucion_codigo
    remove_column :t_resolucions, :resolucion_anio
    add_column :t_resolucions, :resolucion, :string
  end
end
