class CreateTClientePadres < ActiveRecord::Migration[5.2]
  def change
    create_table :t_cliente_padres do |t|
      t.string :codigo, null: false
      t.string :razon_social, null: false
      t.string :tipo_valor, null: false
      t.string :sector_economico, null: false
      t.integer :estatus, null: false

      t.timestamps

      t.belongs_to :t_tipo_persona, foreign_key: true, null: false
      t.belongs_to :t_tipo_cliente, foreign_key: true, null: false
    end
  end
end
