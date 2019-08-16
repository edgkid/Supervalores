class TRol < ApplicationRecord
	has_and_belongs_to_many :users
	has_and_belongs_to_many :elementos
	has_many :t_rol_descs

	validates :nombre, presence: {message: "|El nombre del rol no debe estar en blanco."},
												:on => [:create, :update]
	validates :descripcion,  presence: {message: "|La descripción del rol no debe estar en blanco."},
											  :on => [:create, :update]
	validates :peso,  presence: {message: "|Debe indicar un peso al rol."},
												:on => [:create, :update]
end
