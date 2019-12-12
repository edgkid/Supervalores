class InformePorTiposDeClienteView < ApplicationRecord
  self.table_name = 'informe_por_tipos_de_cliente_view'

  protected
    def readonly?
      true
    end
end
