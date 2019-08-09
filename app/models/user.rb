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

	validates :password,  presence: {message: "|El pasword no debe estar vacío."},
												confirmation: {message: "|La confirmación de pasword debe coincidir."},
												format: { message: "|El password solo debe contener Mayusculas, Minusculas y Números (Minimo 6 caracateres).",
																with: /\A(?=.*[A-Z])(?=.*\d).{6,12}\z/ },
												:on => [:create, :update]

	validates :nombre, :apellido, presence: {message: "|El nombre y apellido no pueden estar vacío."},
											 					format: {
											 					message: "|El nombre y apellido solo acepta caracteres alfabeticos.",
												 				with: /\A[a-zA-Z]*\z/
											 },
											 :on => [:create, :update ]

	 validates :email , presence: {message: "|El email no debe estar vacío y debe contener un formato valido"}

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

	def get_all_rols
		return TRol.all
	end

end
