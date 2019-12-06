# == Schema Information
#
# Table name: t_contactos
#
#  id              :bigint           not null, primary key
#  nombre          :string
#  apellido        :string
#  telefono        :string
#  direccion       :string
#  email           :string
#  empresa         :string
#  t_resolucion_id :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class TContacto < ApplicationRecord
  belongs_to :t_resolucion
    
  validates :nombre,
    presence: {
        message: "|El nombre no puede estar vacía."
    },
    format: {
        message: "|El nombre solo puede tener Letras y espacios.",
        with: /([A-Za-z\s]+)/ 
    },
    :on => [:create, :update]

  validates :apellido,
    presence: {
        message: "|El apellido no puede estar vacía."
    },
    format: {
        message: "|El apellido solo puede tener Letras y espacios.",
        with: /([A-Za-z\s]+)/ 
    },
    :on => [:create, :update]

  validates :telefono,
    presence: {
        message: "|El teléfono no puede estar vacía."
    },
    :on => [:create, :update]

  validates :email,
    presence: {
        message: "|El email no puede estar vacía."
    },
    format: {
        message: "|El email solo puede tener Letras, Números y Guiones(-).",
        with: /.+@.+/  
    },
    :on => [:create, :update]

  validates :direccion,
    presence: {
        message: "|La dirección no puede estar vacía."
    },
    format: {
        message: "|La dirección solo puede tener Letras, Números, Guiones(-) y espacios.",
        with: /([A-Za-z0-9\-\s]+)/ 
    },
    :on => [:create, :update]  
  
  validates :empresa,
    presence: {
        message: "|El empresa no puede estar vacía."
    },
    format: {
        message: "|El empresa solo puede tener Letras, Números, Guiones(-) y espacios.",
        with: /([A-Za-z0-9\-\s]+)/
    },
    :on => [:create, :update]

end
