class InformeDeIngresosDiariosView < ApplicationRecord
  self.table_name = 'informe_consolidado_de_ingresos_view'

  protected
    def readonly?
      true
    end
end

