class AjusteResolucion < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key "t_resolucions", "t_tipo_clientes"
    remove_index "t_resolucions", name: "index_t_resolucions_on_t_tipo_cliente_id"
    remove_column "t_resolucions", "t_tipo_cliente_id"
    
    add_column "t_resolucions", "t_estatus_id", :bigint, null: false
    add_index "t_resolucions", "t_estatus_id"
    add_foreign_key "t_resolucions", "t_estatuses"
    
    add_column "t_resolucions", "resolucion", :string
    add_index "t_resolucions", "resolucion", unique: true
  end
end
