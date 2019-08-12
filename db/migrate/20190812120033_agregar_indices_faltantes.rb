class AgregarIndicesFaltantes < ActiveRecord::Migration[5.2]
  def change
    add_index :t_clientes, :codigo, unique: true
    add_index :t_tipo_clientes, :codigo, unique: true
  end
end
