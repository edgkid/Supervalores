# == Schema Information
#
# Table name: t_modulo_rols
#
#  id          :bigint           not null, primary key
#  t_rol_id    :bigint
#  t_modulo_id :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class TModuloRol < ApplicationRecord
  belongs_to :t_rol
  belongs_to :t_modulo

  has_many :t_permiso_modulo_rols, dependent: :destroy
  has_many :t_permisos, through: :t_permiso_modulo_rols
end
