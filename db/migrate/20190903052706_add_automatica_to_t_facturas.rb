class AddAutomaticaToTFacturas < ActiveRecord::Migration[5.2]
  def change
    add_column :t_facturas, :automatica, :boolean, default: false
  end
end
