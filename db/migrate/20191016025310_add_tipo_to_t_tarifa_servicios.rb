class AddTipoToTTarifaServicios < ActiveRecord::Migration[5.2]
  def change
    add_column :t_tarifa_servicios, :tipo, :string
  end
end
