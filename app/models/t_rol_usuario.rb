# == Schema Information
#
# Table name: t_rol_usuarios
#
#  id         :bigint           not null, primary key
#  user_id    :bigint
#  t_rol_id   :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TRolUsuario < ApplicationRecord
  belongs_to :user
  belongs_to :t_rol
end
