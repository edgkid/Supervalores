# == Schema Information
#
# Table name: informe_de_ingresos_presupuesto_view
#
#  id              :bigint
#  codigo          :string
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

class InformeDeIngresosPresupuestoView < ApplicationRecord
  self.table_name = 'informe_de_ingresos_presupuesto_view'

  protected
    def readonly?
      true
    end
end
