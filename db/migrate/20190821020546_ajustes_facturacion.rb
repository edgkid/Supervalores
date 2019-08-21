class AjustesFacturacion < ActiveRecord::Migration[5.2]
  def change
    add_column :t_tipo_clientes, :t_periodo_id, :bigint
    add_column :t_recargos, :t_periodo_id, :bigint
  end
end
