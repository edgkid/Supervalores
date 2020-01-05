class CuentasXCobrarXClienteView < ApplicationRecord
  self.table_name = 'cuentas_x_cobrar_x_cliente_view'

  protected
    def readonly?
      true
    end
end
