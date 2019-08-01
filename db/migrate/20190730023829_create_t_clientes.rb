class CreateTClientes < ActiveRecord::Migration[5.2]
  def change
    create_table :t_clientes do |t|
      t.string :codigo, null: false
      t.integer :prospecto, null: false
      t.date :prospecto_date_int
      t.date :prospecto_date_out
      t.string :nombre
      t.string :apellido
      t.string :cedula
      t.string :empresa
      t.string :cargo
      t.string :direccion_empresa
      t.string :telefono
      t.string :fax
      t.string :email
      t.string :web
      t.bigint :num_licencia
      t.integer :estatus, null: false

      t.timestamps

      t.belongs_to :t_cliente_padre, foreign_key: true, null: false
      #t.belongs_to :t_tipo_cliente, foreign_key: true
      #t.belongs_to :t_tipo_emision, foreign_key: true
      t.belongs_to :t_catalogo_cuenta_sub, foreign_key: true, null: false
      t.belongs_to :t_cuenta_ventum, foreign_key: true
      t.belongs_to :user, foreign_key: true, null: false, null: false

    end
  end
end
