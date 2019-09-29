class DropTRolsTable < ActiveRecord::Migration[5.2]
  def self.up
    #drop_table :t_users_rols
    #drop_table :t_rol_descs
    #drop_table :t_rols
  end

  def self.down
    create_table :t_rols do |t|
      t.string :direccion_url
      t.string :li_class
      t.string :i_class
      t.string :u_class
      t.string :nombre, null: false
      t.string :descripcion, null: false
      t.integer :peso
      t.integer :estatus, null: false
      t.string :icon_class

      t.timestamps
    end

    create_table :t_rol_descs do |t|
      t.string :id_objeto
      t.string :nombre, null: false
      t.text :pagina
      t.integer :estatus, null: false

      t.timestamps

      t.belongs_to :t_rol, foreign_key: true, null: false
    end

    create_table :t_users_rols, id: false do |t|
      t.belongs_to :t_rol, foreign_key: true, index: true, null: false
      t.belongs_to :user, foreign_key: true, index: true, null: false
    end
  end
end
