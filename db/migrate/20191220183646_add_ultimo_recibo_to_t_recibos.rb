class AddUltimoReciboToTRecibos < ActiveRecord::Migration[5.2]
  def change
    add_column :t_recibos, :ultimo_recibo,    :boolean, default: true
  end
end
