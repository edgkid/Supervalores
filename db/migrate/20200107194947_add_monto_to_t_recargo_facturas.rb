class AddMontoToTRecargoFacturas < ActiveRecord::Migration[5.2]
  def change
    add_column :t_recargo_facturas, :monto, :decimal
  end
end
