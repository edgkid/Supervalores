class CreateElementos < ActiveRecord::Migration[5.2]
  def change
    create_table :elementos do |t|
      t.string :nombre
      t.string :modelo

      t.timestamps
    end
  end
end
