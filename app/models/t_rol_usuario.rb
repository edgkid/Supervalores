class TRolUsuario < ApplicationRecord
  belongs_to :user
  belongs_to :t_rol
end
