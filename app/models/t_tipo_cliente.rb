class TTipoCliente < ApplicationRecord
	belongs_to :t_tarifa
	
	has_many :t_cliente	
	#has_and_belongs_to_many :t_tarifa

	validates :codigo, 
		presence: {
			message: "|El código no puede estar vacío."
		},
    format: { 
      message: "|El código solo puede tener Letras, Números y Guiones(-).",
      with: /([A-Za-z0-9\-]+)/ 
    },
		length: {
			message: "|El código debe tener entre 6 y 18 caracteres",
			minimum: 2,
			maximum: 18
		},
		:on => [:create, :update]

	validates :descripcion, 
		presence: {
			message: "|El descripción no puede estar vacío."
		},
		length: {
			message: "|La descripción debe tener minimo 4 caracteres.",
			minimum: 4
		},
		:on => [:create, :update]

	validates :tipo, 
		presence: {
			message: "|El tipo no puede estar vacío."
		},
		:on => [:create, :update]

	validates :estatus, 
		presence: {
			message: "|El estatus no puede estar vacío."
		},
    format: { 
      message: "|El código solo puede tener Letras, Números y Guiones(-).",
      with: /([0|1])/ 
    },
		:on => [:create, :update]

	validates :t_tarifa_id, 
		presence: {
			message: "|Debe indicar la tarifa asociada al tipo de cliente."
		},
		:on => [:create, :update]

  before_save :before_save_record

  def before_save_record
    codigo.upcase!
  end
end
