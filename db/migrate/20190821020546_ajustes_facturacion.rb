class AjustesFacturacion < ActiveRecord::Migration[5.2]
  def change
    add_column :t_tipo_clientes, :t_periodo_id, :bigint
    add_column :t_recargos, :t_periodo_id, :bigint
    
    remove_column :t_resolucions, :resolucion
    
    add_column :t_resolucions, :resolucion_anio, :int
    add_column :t_resolucions, :resolucion_codigo, :string
    add_index :t_resolucions, [:resolucion_anio, :resolucion_codigo], unique: true

    change_column :t_facturas, :recargo_desc, :string
  end
end
