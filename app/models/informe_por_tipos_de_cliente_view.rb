# == Schema Information
#
# Table name: informe_por_tipos_de_cliente_view
#
#  id              :bigint
#  descripcion     :string
#  anio_pago       :float
#  pago_enero      :float
#  pago_febrero    :float
#  pago_marzo      :float
#  pago_abril      :float
#  pago_mayo       :float
#  pago_junio      :float
#  pago_julio      :float
#  pago_agosto     :float
#  pago_septiembre :float
#  pago_octubre    :float
#  pago_noviembre  :float
#  pago_diciembre  :float
#  total           :float
#

class InformePorTiposDeClienteView < ApplicationRecord
  self.table_name = 'informe_por_tipos_de_cliente_view'

  protected
    def readonly?
      true
    end
end
