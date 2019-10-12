class AcceptNullPeriodsOnTFacturas < ActiveRecord::Migration[5.2]
  def change
    change_column_null :t_facturas, :t_periodo_id, true
  end
end
