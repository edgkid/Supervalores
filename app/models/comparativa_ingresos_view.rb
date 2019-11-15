class ComparativaIngresosView < ApplicationRecord
  self.table_name = 'comparativa_ingresos_view'

  protected
    def readonly?
      true
    end
end
