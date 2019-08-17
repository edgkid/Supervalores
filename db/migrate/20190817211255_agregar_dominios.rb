class AgregarDominios < ActiveRecord::Migration[5.2]
  def change
    create_table :t_empresa_tipo_valors do |t|
      t.string :descripcion
      t.integer :estatus

      t.timestamps
    end

    create_table :t_empresa_sector_economicos do |t|
      t.string :descripcion
      t.integer :estatus

      t.timestamps
    end

    create_table :t_tipo_cliente_tipos do |t|
      t.string :descripcion
      t.integer :estatus

      t.timestamps
    end
    
    remove_column :t_empresas, :tipo_valor
    remove_column :t_empresas, :sector_economico
    remove_column :t_tipo_clientes, :tipo

    add_column :t_empresas, :t_empresa_tipo_valor_id, :bigint
    add_column :t_empresas, :t_empresa_sector_economico_id, :bigint
    add_column :t_tipo_clientes, :t_tipo_cliente_tipo_id, :bigint

    add_foreign_key :t_empresas, :t_empresa_tipo_valors
    add_foreign_key :t_empresas, :t_empresa_sector_economicos
    add_foreign_key :t_tipo_clientes, :t_tipo_cliente_tipos
  end
end
