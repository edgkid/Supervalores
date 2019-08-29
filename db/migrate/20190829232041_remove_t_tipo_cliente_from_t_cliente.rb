class RemoveTTipoClienteFromTCliente < ActiveRecord::Migration[5.2]
  def change
    remove_column :t_clientes, :t_tipo_cliente_id, :bigint
  end
end
