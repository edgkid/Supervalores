class TUsersRols < ActiveRecord::Migration[5.2]
  def change

  	create_table :t_users_rols, id: false do |t|

    	t.belongs_to :t_rol, foreign_key: true, index: true, null: false
    	t.belongs_to :user, foreign_key: true, index: true, null: false

    end

  end
end
