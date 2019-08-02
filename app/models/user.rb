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
end
