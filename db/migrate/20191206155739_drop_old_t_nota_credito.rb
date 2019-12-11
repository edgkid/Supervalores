class DropOldTNotaCredito < ActiveRecord::Migration[5.2]
  def change
  	drop_table :t_nota_creditos
  end
end
