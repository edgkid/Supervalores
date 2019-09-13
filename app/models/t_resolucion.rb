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

	validates :descripcion,
		presence: {
			message: "|La descripción no puede estar vacía."
		},
		length: {
			message: "|La descripción debe tener minimo 2 caracteres.",
			minimum: 2
		},
		on: [:create, :update]

	validates :t_cliente_id,
		presence: {
			message: "|Debe indicar el cliente asociado a la resolución."
		},
		on: [:create, :update]

	validates :t_estatus_id,
		presence: {
			message: "|Debe indicar el estatus asociado a la resolución."
		},
		on: [:create, :update]

	validates :resolucion_codigo,
		presence: {
			message: "|El codigo de la resolución no puede estar vacío."
		},
    format: { 
      message: "|La resolución solo puede tener Letras, Números, Guiones(-).",
      with: /([A-Za-z0-9\-]+)/ 
		},
		on: [:create, :update]
	
	validates :resolucion_anio,
		presence: {
			message: "|La resolución no puede estar vacía."
		},
    format: { 
      message: "|La resolución solo puede tener Números.",
      with: /([0-9]+)/ 
		},
		on: [:create, :update]
		
	validates :resolucion_anio, 
		uniqueness: {
			scope: :resolucion_codigo,
			message: "|Ya se registró esta resolución a un cliente, use otra por favor.",
		}

		validates :num_licencia,
		presence: {
				message: "|El número licencia no puede estar vacía."
		},
		:on => [:create, :update]

	
	attr_accessor :usar_cliente

	def resolucion_codigo=(resolucion_codigo)
		write_attribute(:resolucion_codigo, normalizar(resolucion_codigo))
	end
	
	def resolucion_codigo
		read_attribute(:resolucion_codigo)
	end

	def resolucion
		"SMV#{resolucion_codigo}#{resolucion_anio}"# if defined?(resolucion_anio)
	end

	private
	
	def normalizar(codigo)
		if codigo
			value = codigo.strip()[0..5]
			return "#{"0"*(6-value.length)}#{value}"
		end
		return "0000"
	end

end
