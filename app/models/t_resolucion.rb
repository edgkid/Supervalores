class TResolucion < ApplicationRecord
	belongs_to :t_cliente	
	belongs_to :t_estatus
  belongs_to :t_tipo_cliente

	has_one :t_contacto, dependent: :destroy
	has_many :t_facturas, dependent: :destroy
	has_many :t_recargo_x_clientes, dependent: :destroy
	has_many :t_recargos, through: :t_recargo_x_cliente
	has_many :t_cliente_tarifas, dependent: :destroy
	has_many :t_tarifas, through: :t_cliente_tarifa
	
#	validates :codigo,
#		presence: {
#				message: "|El código de la resolución no puede estar vacío."
#		},
#		:on => [:create, :update]

	validates :num_licencia,
		presence: {
				message: "|El número licencia no puede estar vacía."
		},
		:on => [:create, :update]
	
	attr_accessor :usar_cliente
	
	validate :validando_dependencias
	def validando_dependencias
		if resolucion != nil && resolucion != ""
			on_assert_add_error resolucion_codigo == nil || resolucion_codigo == '', :resolucion, '|Debe indicar el código de la resolución.'
			on_assert_add_error resolucion_anio == nil || resolucion_anio == '', :resolucion, '|Debe indicar el año de la resolución.'
		else
			on_assert_add_error true, :resolucion, '|La resolución no tiene un formato valido, ej SMV{código}{año}.'
		end
		on_assert_add_error t_cliente_id == nil && t_cliente == nil, :t_cliente_id, '|Debe indicar el cliente asociado a la resolución.'
		on_assert_add_error t_estatus_id == nil && t_estatus == nil, :t_estatus_id, '|Debe indicar el estatus asociado a la resolución.'
	end
	
	attr_accessor :usar_cliente
	
	def resolucion_codigo
		if resolucion != nil && resolucion != ""
			grupos = resolucion.scan(/(SMV)([A-Za-z0-9]+)([0-9]{4})/)
			if grupos.at(0) != nil
				return grupos.at(0).at(1)
			end
		end
		return ""
	end
	
	def resolucion_anio
		if resolucion != nil && resolucion != ""
			grupos = resolucion.scan(/(SMV)([A-Za-z0-9]+)([0-9]{4})/)
			if grupos.at(0) != nil
				return grupos.at(0).at(2)
			end
		end
		return ""
	end

	private
	
	def normalizar(codigo)
		if codigo
			value = codigo.strip()[0..5]
			return "#{"0"*(6-value.length)}#{value}"
		end
		return nil
	end

end
