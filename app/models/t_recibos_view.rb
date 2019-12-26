class TRecibosView < ApplicationRecord
  self.table_name = 't_recibos_view'

  protected
    def readonly?
      true
    end
end
