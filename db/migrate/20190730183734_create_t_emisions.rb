class CreateTEmisions < ActiveRecord::Migration[5.2]
  def change
    create_table :t_emisions do |t|
      t.date :fecha_emision, null: false
      t.float :valor_circulacion, null: false
      t.float :tasa, null: false
      t.float :monto_pagar, null: false
      t.integer :estatus, null: false

      t.timestamps

      #t.belongs_to :t_cliente, foreign_key: true, null: false
      t.belongs_to :t_periodo, foreign_key: true, null: false
      t.belongs_to :t_tipo_emision, foreign_key: true, null: false
      t.belongs_to :user, foreign_key: true, null: false

    end
  end
end
