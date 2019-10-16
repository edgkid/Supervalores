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

	validates :resolucion,
		presence: {
			message: "|El codigo de la resolución no puede estar vacío."
		},
    format: { 
      message: "|La resolución solo puede tener Letras, Números, Guiones(-).",
      with: /SVM([A-Za-z0-9\-]+)([0-9]+)/ 
		},
		on: [:create, :update]

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

	def resolucion_anio=(resolucion_anio)
		write_attribute(:resolucion_anio, resolucion_anio)
	end
	
	def resolucion_anio
		read_attribute(:resolucion_anio)
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
