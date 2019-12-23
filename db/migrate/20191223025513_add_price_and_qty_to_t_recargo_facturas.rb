class AddPriceAndQtyToTRecargoFacturas < ActiveRecord::Migration[5.2]
  def change
    add_column :t_recargo_facturas, :cantidad, :integer
    add_column :t_recargo_facturas, :precio_unitario, :decimal
  end
end
