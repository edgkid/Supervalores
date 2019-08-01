class TRol < ApplicationRecord
	has_and_belongs_to_many :user
	has_many :t_rol_desc
end
