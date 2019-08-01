class CreateTEstatusFacs < ActiveRecord::Migration[5.2]
  def change
    create_table :t_estatus_facs do |t|
      t.string :descripcion
      t.integer :estatus
      t.string :color

      t.timestamps
    end
  end
end
