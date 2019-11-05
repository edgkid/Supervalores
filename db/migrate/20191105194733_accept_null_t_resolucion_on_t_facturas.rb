class AcceptNullTResolucionOnTFacturas < ActiveRecord::Migration[5.2]
  def change
    change_column_null :t_facturas, :t_resolucion_id, true
  end
end
