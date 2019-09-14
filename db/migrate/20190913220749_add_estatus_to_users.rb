class AddEstatusToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :estatus, :integer
    remove_column :users, :estado, :boolean
  end
end
