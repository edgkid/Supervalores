class AddFacturaRefToTRecargos < ActiveRecord::Migration[5.2]
  def change
    add_reference :t_recargos, :t_factura, foreign_key: true
  end
end
