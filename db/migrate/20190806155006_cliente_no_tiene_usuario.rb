class ClienteNoTieneUsuario < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key "t_clientes", "users"
    remove_index "t_clientes", name: "index_t_clientes_on_user_id"
    remove_column "t_clientes", "user_id"
  end
end
