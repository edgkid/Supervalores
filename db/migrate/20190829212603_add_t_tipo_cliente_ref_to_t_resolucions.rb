class AddTTipoClienteRefToTResolucions < ActiveRecord::Migration[5.2]
  def change
    add_reference :t_resolucions, :t_tipo_cliente, foreign_key: true
  end
end
