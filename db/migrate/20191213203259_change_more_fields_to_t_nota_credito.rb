class ChangeMoreFieldsToTNotaCredito < ActiveRecord::Migration[5.2]
  def change
  	rename_column :t_nota_creditos, :monto_restante, :monto_original
  	rename_column :t_nota_creditos, :factura_redimida, :t_factura_id
  end
end
