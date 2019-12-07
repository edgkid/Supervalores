class InformeDeClientesView < ApplicationRecord
  self.table_name = 'informe_de_clientes_view'

  protected
    def readonly?
      true
    end
end
