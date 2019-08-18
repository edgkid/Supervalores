class Automatizacion < ActiveRecord::Migration[5.2]
  def change
    remove_column :t_periodos, :mes_tope_desc
  end
end
