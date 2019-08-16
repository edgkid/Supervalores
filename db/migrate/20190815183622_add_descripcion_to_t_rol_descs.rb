class AddDescripcionToTRolDescs < ActiveRecord::Migration[5.2]
  def change
    add_column :t_rol_descs, :descripcion, :text
  end
end
