class AddTPresupuestoRefToTTarifaServicios < ActiveRecord::Migration[5.2]
  def change
    add_reference :t_tarifa_servicios, :t_presupuesto, foreign_key: true
  end
end
