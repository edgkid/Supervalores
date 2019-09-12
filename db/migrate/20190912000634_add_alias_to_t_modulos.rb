class AddAliasToTModulos < ActiveRecord::Migration[5.2]
  def change
    add_column :t_modulos, :alias, :string
  end
end
