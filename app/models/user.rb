class User < ApplicationRecord
	has_and_belongs_to_many :t_roles

	has_many :t_clientes, dependent: :destroy
	has_many :t_facturas, dependent: :destroy
	has_many :t_recibos, dependent: :destroy
	has_many :t_cajas, dependent: :destroy
	has_many :t_estado_cuentums, dependent: :destroy
	has_many :t_email_masivos, dependent: :destroy
	has_many :t_emisions, dependent: :destroy
	has_many :t_nota_creditos, dependent: :destroy

	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :timeoutable

   def get_user_rol(id)

	 	select = " SELECT r.nombre, r.descripcion, r.peso, r.estatus"
		from = " FROM users u, t_users_rols ur, t_rols r"
		where = " WHERE u.id = ur.user_id AND ur.t_rol_id = r.id AND r.estatus = 1 AND u.id = " << id
		sql = select << from << where

		results = ActiveRecord::Base.connection.execute(sql)

		if results.present?
			puts results
			return results
		else
			return nil
		end

	end

end
