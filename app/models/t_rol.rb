class TRol < ApplicationRecord
  has_many :t_rol_usuarios, dependent: :destroy
  has_many :users, through: :t_rol_usuarios
  has_many :t_modulo_rols, dependent: :destroy
  has_many :t_modulos, through: :t_modulo_rols
end
