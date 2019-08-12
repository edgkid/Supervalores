class TResolucion < ApplicationRecord
	belongs_to :t_cliente	
	belongs_to :t_estatus	

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
			message: "|La descripción debe tener minimo 10 caracteres.",
			minimum: 10
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

	validates :resolucion,
		presence: {
			message: "|La resolución no puede estar vacía."
		},
    format: { 
      message: "|La resolución solo puede tener Letras, Números, Guiones(-).",
      with: /([A-Za-z0-9\-]){6,18}/ 
		},
		length: {
			message: "|La resolución debe tener solo entre 6 y 18 caracteres",
			minimum: 6,
			maximum: 18
		},
		on: [:create, :update]

		before_save :before_save_record

		def before_save_record
			resolucion.upcase!
		end

end
