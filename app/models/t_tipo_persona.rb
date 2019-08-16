class TTipoPersona < ApplicationRecord
  
  validates :descripcion, 
		presence: {
			message: "|El descripción no puede estar vacío."
		},
		length: {
			message: "|La descripción debe tener minimo 2 caracteres.",
			minimum: 2
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
    
end
