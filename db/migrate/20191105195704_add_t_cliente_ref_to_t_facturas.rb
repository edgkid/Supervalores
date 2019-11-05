class AddTClienteRefToTFacturas < ActiveRecord::Migration[5.2]
  def change
    add_reference :t_facturas, :t_cliente, foreign_key: true
  end
end
