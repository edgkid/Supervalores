class TRol < ApplicationRecord
	has_and_belongs_to_many :users
	has_many :t_rol_descs
end
