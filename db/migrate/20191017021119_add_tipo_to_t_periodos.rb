class AddTipoToTPeriodos < ActiveRecord::Migration[5.2]
  def change
    add_column :t_periodos, :tipo, :string
  end
end
