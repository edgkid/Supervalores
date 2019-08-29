class AddAmountToTTarifas < ActiveRecord::Migration[5.2]
  def change
    add_column :t_tarifas, :monto, :decimal
  end
end
