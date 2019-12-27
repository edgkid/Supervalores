class EstadoDeCuentaView < ApplicationRecord
  self.table_name = 'estado_de_cuenta_view'

  protected
    def readonly?
      true
    end
end
