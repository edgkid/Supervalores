class TPermiso < ApplicationRecord
  has_many :t_permiso_modulo_rols, dependent: :destroy
  has_many :t_modulo_rols, through: :t_permiso_modulo_rols

  PERMISOS = [
    'create',
    'read',
    'update',
    'destroy'
  ]
end
