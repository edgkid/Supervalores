class CreateTElementos < ActiveRecord::Migration[5.2]
  def change
    create_table :t_elementos do |t|
      t.string :nombre
      t.string :modelo

      t.timestamps
    end
  end
end
