# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  nombre                 :string
#  apellido               :string
#  avatar                 :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  picture                :string
#  role                   :string
#  estatus                :integer
#

class User < ApplicationRecord
	mount_uploader :picture, PictureUploader

  has_many :t_rol_usuarios, dependent: :destroy
	has_many :t_rols, through: :t_rol_usuarios
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

  validates :email,
            presence: {
              message: "|El email no debe estar vacío y debe contener un formato válido"
            }

	validates :password,
            presence: { message: "|La contraseña no debe estar vacía." },
						confirmation: { message: "|La confirmación de contraseña debe coincidir." },
						#format: { message: "|La contraseña debe contener al menos una mayúscula, una minúscula y un número (mínimo 6 caracteres).",
						#with: /\A(?=.*[A-Z])(?=.*\d).{6,12}\z/ },
            allow_blank: true

	validates :nombre,
            presence: { message: "|El nombre no puede estar vacío." },
						format: {
              message: "|El nombre solo acepta caracteres alfabéticos.",
							with: /\A[A-ZÁ-ÚÑ][a-zá-úñ]+\z/
						}

  validates :apellido,
            presence: { message: "|El apellido no puede estar vacío." },
            format: {
              message: "|El apellido solo acepta caracteres alfabéticos.",
              with: /\A(?!.*\s\s)(?!.*'')(?!.*\s\.)(?!.*[a-zá-úñ][A-ZÁ-ÚÑ])[A-ZÁ-ÚÑ][a-zá-úñA-ZÁ-Ú' ]+\z/
            }

	def nombre_completo
		"#{nombre} #{apellido}"
	end

  def has_role?(t_rol_name)
    t_rols.any? {|t_rol| t_rol.nombre == t_rol_name}
  end

  def is_admin?
    has_role?("Administrador")
  end
end
