# == Schema Information
#
# Table name: t_permisos
#
#  id         :bigint           not null, primary key
#  nombre     :string
#  estatus    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TPermiso < ApplicationRecord
  has_many :t_permiso_modulo_rols, dependent: :destroy
  has_many :t_modulo_rols, through: :t_permiso_modulo_rols

  PERMISOS = %w[create read update destroy]

  PERMISOS_ESPECIALES = [
    # Permisos especiales para la factura
    'generate_pdf',
    'send_email',
    # Permiso especial para el recibo
    'generate_receipt',
    # Permiso especial para la lectura de reportes
    'read_reports'
  ]
end
