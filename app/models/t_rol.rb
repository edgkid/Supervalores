class TRol < ApplicationRecord
	has_and_belongs_to_many :users
	has_and_belongs_to_many :t_elementos
	has_many :t_rol_descs

	validates :nombre, presence: {message: "|El nombre del rol no debe estar en blanco."},
												:on => [:create, :update]
	validates :descripcion,  presence: {message: "|La descripción del rol no debe estar en blanco."},
											  :on => [:create, :update]
	validates :peso,  presence: {message: "|Debe indicar un peso al rol."},
												:on => [:create, :update]

	def associate_rol_with_elements (id_rol, elements)
		access = elements.split(",")
		inserted = false
		connection = ActiveRecord::Base.connection()

		access.each do |elemento|

			if elemento.split("-")[0] != "0"
				sql = " INSERT INTO t_elementos_x_rols VALUES ('" << elemento.split("-")[1] << "'," << id_rol << ", (Select id FROM t_elementos WHERE modelo = '" << elemento.split("-")[0] << "')); "

				results =connection.execute (sql)

				if results.present?
					inserted = true
				else
					inserted = false
					next
				end

			end
		end

		return inserted
	end

end
