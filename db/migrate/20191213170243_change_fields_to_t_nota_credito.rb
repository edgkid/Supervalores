class ChangeFieldsToTNotaCredito < ActiveRecord::Migration[5.2]
  def change
  	remove_column :t_nota_creditos, :usada
 	add_column :t_nota_creditos, :monto_restante, :float
 	add_column :t_nota_creditos, :status, :string
  end
end
