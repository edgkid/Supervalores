class InformePorTiposDeIngresoView < ApplicationRecord
  self.table_name = 'informe_por_tipos_de_ingreso_view'

  protected
    def readonly?
      true
    end
end
