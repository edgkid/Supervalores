# == Schema Information
#
# Table name: t_permisos
#
#  id         :bigint           not null, primary key
#  nombre     :string
#  estatus    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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
