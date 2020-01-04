class CajaView < ApplicationRecord
  self.table_name = 'caja_view'

  protected
    def readonly?
      true
    end
end
