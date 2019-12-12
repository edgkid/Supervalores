# == Schema Information
#
# Table name: informe_de_ingresos_presupuesto_view
#
#  t_factura_id :bigint
#  primer_pago  :date
#  ultimo_pago  :date
#  enero        :float
#  febrero      :float
#  marzo        :float
#  abril        :float
#  mayo         :float
#  junio        :float
#  julio        :float
#  agosto       :float
#  septiembre   :float
#  octubre      :float
#  noviembre    :float
#  diciembre    :float
#  total        :float
#

class InformeDeIngresosPresupuestoView < ApplicationRecord
  self.table_name = 'informe_de_ingresos_presupuesto_view'

  protected
    def readonly?
      true
    end
end
