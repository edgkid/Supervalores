class CreateTConfiguracionRecargoTs < ActiveRecord::Migration[5.2]
  def change
    create_table :t_configuracion_recargo_ts do |t|
      t.string :nombre
      t.decimal :tasa

      t.timestamps
    end
  end
end
