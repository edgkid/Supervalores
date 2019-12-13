class ClientePolymorphic < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :t_clientes, :t_tipo_personas
    remove_index :t_clientes, name: "index_t_personas_on_t_tipo_persona_id"
    remove_column :t_clientes, :t_tipo_persona_id
    remove_column :t_clientes, :razon_social
    remove_column :t_clientes, :telefono
    remove_column :t_clientes, :email 
    remove_foreign_key "t_empresas", "t_clientes"
    remove_foreign_key "t_personas", "t_clientes"
    remove_column :t_personas, :t_cliente_id
    remove_column :t_empresas, :t_cliente_id

    create_table :t_otros do |t|
      t.string :identificacion
      t.string :razon_social
      t.string :telefono
      t.string :email
      t.bigint :t_tipo_persona_id
      t.timestamps
    end

    add_column :t_personas, :telefono, :string
    add_column :t_personas, :email, :string
    add_column :t_empresas, :telefono, :string
    add_column :t_empresas, :email, :string
    add_column :t_clientes, :persona_id, :bigint, null: false
    add_column :t_clientes, :persona_type, :string, null: false
    add_index :t_clientes, [:persona_type, :persona_id], name: "index_persona_as_cliente"
    add_index :t_otros, :t_tipo_persona_id, name: "index_t_otros_on_t_tipo_persona_id"
    add_foreign_key :t_otros, :t_tipo_personas
    #add_index :t_personas, :cedula, unique: true
    #add_index :t_empresas, :rif, unique: true
  end
end
