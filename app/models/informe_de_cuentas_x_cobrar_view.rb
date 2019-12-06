# == Schema Information
#
# Table name: informe_de_cuentas_x_cobrar_view
#
#  id                :bigint
#  descripcion       :string
#  cantidad_clientes :bigint
#  cantidad_facturas :bigint
#  dias_0_30         :float
#  dias_31_60        :float
#  dias_61_90        :float
#  dias_91_120       :float
#  dias_mas_de_120   :float
#  total             :float
#

class InformeDeCuentasXCobrarView < ApplicationRecord
  self.table_name = 'informe_de_cuentas_x_cobrar_view'

  protected
    def readonly?
      true
    end
end
