class TClienteTarifa < ApplicationRecord

	t.belongs_to :t_tarifa
    t.belongs_to :t_resolucion
    t.belongs_to :t_periodo

end
