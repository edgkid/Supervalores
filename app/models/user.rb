class User < ApplicationRecord
	
	has_and_belongs_to_many :t_rol

	has_many :t_cliente
	has_many :t_factura
	has_many :t_recibo
	has_many :t_caja
	has_many :t_estado_cuentum
	has_many :t_email_masivo
	has_many :t_emision
	has_many :t_nota_credito
	
  	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :timeoutable
end
