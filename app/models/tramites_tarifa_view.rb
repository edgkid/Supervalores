class TramitesTarifaView < ApplicationRecord
  self.table_name = 'tramites_de_tarifa_view'

  protected
    def readonly?
      true
    end
end
