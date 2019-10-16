class DigitoVerificadorCliente < ActiveRecord::Migration[5.2]
  def change
    add_column :t_clientes, :dv, :string
  end
end
