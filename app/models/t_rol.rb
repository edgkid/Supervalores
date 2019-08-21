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
		inserted = true
		connection = ActiveRecord::Base.connection()

		access.each do |elemento|

			if elements != nil && elemento.split("-")[0] != "0"
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

	def clean_permisssions (elements)
		elements_list = elements.split(",").sort.reverse
		permissions_list = elements.split(",").sort.reverse

		elements_list.each do |element|
			if element.split("-")[0] == "m"

				count = 0
				permissions_list.each do |permission|
					if element.split("-")[1] == permission.split("-")[1]
						if permission.split("-")[0] == "l" || permission.split("-")[0] == "g" || permission.split("-")[0] == "a"
							permissions_list.delete_at(count)
						end
					end
					count = count + 1
					elements_list = permissions_list
				end

			end
		end

		return verify_permission_cleanup (elements_list)
	end

	def verify_permission_cleanup (elements_list)

		permissions_list = elements_list
		elements_list.each do |element|
			if element.split("-")[0] == "m"

				count = 0
				permissions_list.each do |permission|
					if element.split("-")[1] == permission.split("-")[1]
						if permission.split("-")[0] == "l" || permission.split("-")[0] == "g" || permission.split("-")[0] == "a"
							permissions_list.delete_at(count)
						end
					end
					count = count + 1
					elements_list = permissions_list
				end

			end
		end

		return permissions_list
	end

end
