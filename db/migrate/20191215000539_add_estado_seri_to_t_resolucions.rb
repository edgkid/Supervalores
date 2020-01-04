class AddEstadoSeriToTResolucions < ActiveRecord::Migration[5.2]
  def change
  	add_column :t_resolucions, :estado_seri, :string
  end
end
