class TEstatus < ApplicationRecord

	has_many :t_facturas
	has_many :t_clientes
	has_many :recibos

	validates :estatus,
		presence: {
			message: "|El estatus no puede estar vacío."
		},
		on: [:create, :update]

	validates :para,
		presence: {
			message: "|El para quien se destina este estatus no puede estar vacío."
		},
		on: [:create, :update]

	validates :descripcion,
		presence: {
			message: "|La descripción no puede estar vacía."
		},
		length: {
			message: "|La descripción debe tener minimo 2 caracteres.",
			minimum: 2
		},
		on: [:create, :update]

	validates :color,
		presence: {
			message: "|El color no puede estar vacío."
		},
    format: {
      message: "|El color debe tener formato hexadécimal de 3, 6 ó 8 caracteres, #123ABCFF.",
      with: /(\#(?:[0-9A-Fa-f]{3})(?:[0-9A-Fa-f]{3}(?:[0-9A-Fa-f]{2})*)*)/
    },
		on: [:create, :update]


end
