class RemoveTFacturaIdFromTRecargos < ActiveRecord::Migration[5.2]
  def change
    remove_reference :t_recargos, :t_factura, foreign_key: true
  end
end
