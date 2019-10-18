class CodigoClienteOpcional < ActiveRecord::Migration[5.2]
  def change
    change_column :t_clientes, :codigo, :string, :null => true
  end
end
