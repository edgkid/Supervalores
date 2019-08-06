class RemoveForeignKeysFromTTarifaServicios < ActiveRecord::Migration[5.2]
  def change
    remove_reference :t_tarifa_servicios, :t_tarifa_servicio_group, foreign_key: true
    remove_reference :t_tarifa_servicios, :t_catalogo_cuenta_sub, foreign_key: true
  end
end
