class TModuloRol < ApplicationRecord
  belongs_to :t_rol
  belongs_to :t_modulo

  has_many :t_permiso_modulo_rols, dependent: :destroy
  has_many :t_permisos, through: :t_permiso_modulo_rols
end
