class InformeDeRecaudacionView < ApplicationRecord
  self.table_name = 'informe_de_recaudacion_view'

  protected
    def readonly?
      true
    end
end
