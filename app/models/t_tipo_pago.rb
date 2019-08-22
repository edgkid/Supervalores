class TTipoPago < ApplicationRecord

  has_many :t_recibos
  belongs_to :t_estatus
end
