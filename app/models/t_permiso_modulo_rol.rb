# == Schema Information
#
# Table name: t_permiso_modulo_rols
#
#  id              :bigint           not null, primary key
#  t_permiso_id    :bigint
#  t_modulo_rol_id :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class TPermisoModuloRol < ApplicationRecord
  belongs_to :t_permiso
  belongs_to :t_modulo_rol
end
