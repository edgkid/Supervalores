class TClienteTarifa < ApplicationRecord
	belongs_to :t_tarifa
  belongs_to :t_resolucion
  belongs_to :t_periodo
end
