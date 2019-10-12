class AcceptNullPeriodsOnTRecibos < ActiveRecord::Migration[5.2]
  def change
    change_column_null :t_recibos, :t_periodo_id, true
  end
end
