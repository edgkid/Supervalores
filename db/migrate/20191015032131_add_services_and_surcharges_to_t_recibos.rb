class AddServicesAndSurchargesToTRecibos < ActiveRecord::Migration[5.2]
  def change
    add_column :t_recibos, :recargo_x_pagar, :decimal
    add_column :t_recibos, :servicios_x_pagar, :decimal
  end
end
