class DvEmpresas < ActiveRecord::Migration[5.2]
  def change
    remove_column :t_clientes, :dv
    remove_index :t_clientes, name: "index_t_clientes_on_codigo"
    add_column :t_empresas, :dv, :string
  end
end
