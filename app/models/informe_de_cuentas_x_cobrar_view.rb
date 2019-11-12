class InformeDeCuentasXCobrarView < ApplicationRecord
  self.table_name = 'informe_de_cuentas_x_cobrar_view'

  protected
    def readonly?
      true
    end
end
