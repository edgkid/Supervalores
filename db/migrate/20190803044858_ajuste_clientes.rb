class AjusteClientes < ActiveRecord::Migration[5.2]
  def change
    reversible do |change|
      change.up do
        remove_foreign_key "t_email_masivos", "t_clientes"
        remove_foreign_key "t_estado_cuenta", "t_clientes"
        remove_foreign_key "t_nota_creditos", "t_clientes"
        #remove_foreign_key "t_recargo_x_clientes", "t_clientes"
        remove_foreign_key "t_recibos", "t_clientes"
        remove_foreign_key "t_resolucions", "t_clientes"
        remove_foreign_key "t_clientes", "t_cliente_padres"
        drop_table "t_clientes"

        drop_table "t_cliente_padres"

        remove_foreign_key "t_facturas", "t_estatus_facs"
        rename_column "t_facturas", "t_estatus_fac_id", "t_estatus_id"
        remove_index "t_facturas", name: "index_t_facturas_on_t_estatus_id"
        add_index "t_facturas", "t_estatus_id" , name: "index_t_facturas_on_t_estatus_id"
        drop_table "t_estatus_facs"

        add_column "t_resolucions", "resolucion", :string
        add_index "t_resolucions", "resolucion", unique: true

        create_table "t_estatus", force: :cascade do |t|
          t.integer "estatus", null: false
          t.integer "para", null: false, :default => 0
          t.string "descripcion", null: false
          t.string "color", null: false
          t.datetime "created_at", null: false
          t.datetime "updated_at", null: false
        end
        add_foreign_key :t_facturas, :t_estatus

        create_table "t_clientes", force: :cascade do |t|
          t.string "codigo", null: false
          t.integer "t_estatus_id", null: false
          t.index ["t_estatus_id"], name: "index_t_clientes_on_t_estatus_id"
          t.datetime "created_at", null: false
          t.datetime "updated_at", null: false
          t.bigint "t_tipo_cliente_id", null: false
          t.index ["t_tipo_cliente_id"], name: "index_t_clientes_on_t_tipo_cliente_id"
          t.bigint "t_tipo_persona_id", null: false
          t.index ["t_tipo_persona_id"], name: "index_t_personas_on_t_tipo_persona_id"
          t.bigint "user_id", null: false
          t.index ["user_id"], name: "index_t_clientes_on_user_id"
          t.string "razon_social"
          t.string "telefono"
          t.string "email"
          t.date "prospecto_at"
        end

        add_foreign_key "t_clientes", "t_tipo_clientes"
        add_foreign_key "t_clientes", "t_tipo_personas"
        add_foreign_key "t_clientes", "users"
        add_foreign_key "t_clientes", "t_estatus"

        add_foreign_key "t_email_masivos", "t_clientes"
        add_foreign_key "t_estado_cuenta", "t_clientes"
        add_foreign_key "t_nota_creditos", "t_clientes"
        #add_foreign_key "t_recargo_x_clientes", "t_clientes"
        add_foreign_key "t_recibos", "t_clientes"
        add_foreign_key "t_resolucions", "t_clientes"

        create_table "t_empresas", force: :cascade do |t|
          t.string "rif", null: false
          t.string "razon_social", null: false
          t.string "tipo_valor", null: false
          t.string "sector_economico", null: false
          t.string "direccion_empresa"
          t.string "fax"
          t.string "web"
          t.bigint "t_cliente_id"
          t.index ["t_cliente_id"], name: "index_t_empresas_on_t_cliente_id"
        end
        add_foreign_key "t_empresas", "t_clientes"

        create_table "t_personas", force: :cascade do |t|
          t.string "cedula", null: false
          t.string "nombre", null: false
          t.string "apellido", null: false
          t.bigint "num_licencia", null: false
          t.datetime "created_at", null: false
          t.datetime "updated_at", null: false
          t.bigint "t_cliente_id", null: false
          t.index ["t_cliente_id"], name: "index_t_personas_on_t_cliente_id"
          t.bigint "t_empresa_id"
          t.index ["t_empresa_id"], name: "index_t_personas_on_t_empresa_id"
          t.string "cargo"
        end

        add_foreign_key "t_personas", "t_clientes"
        add_foreign_key "t_personas", "t_empresas"

      end

      change.down do
        raise ActiveRecord::IrreversibleMigration, "Can't recover the deleted data"
      end
    end
  end
end
