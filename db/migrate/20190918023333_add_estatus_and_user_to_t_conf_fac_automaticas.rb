class AddEstatusAndUserToTConfFacAutomaticas < ActiveRecord::Migration[5.2]
  def change
    add_column :t_conf_fac_automaticas, :estatus, :integer
    add_reference :t_conf_fac_automaticas, :user, foreign_key: true
  end
end
