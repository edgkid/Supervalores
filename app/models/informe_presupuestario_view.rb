class InformePresupuestarioView < ApplicationRecord
  self.table_name = 'informe_presupuestario_view'

  protected
    def readonly?
      true
    end
end
