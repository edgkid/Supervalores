# == Schema Information
#
# Table name: informe_consolidado_de_ingresos_view
#
#  id                 :bigint
#  justificacion      :string
#  pago_recibido      :float
#  fecha_pago         :date
#  t_factura_id       :bigint
#  fecha_notificacion :date
#  fecha_vencimiento  :date
#  identificacion     :string
#  razon_social       :string
#  tipo_cliente       :string
#

class InformeDeIngresosDiariosView < ApplicationRecord
  self.table_name = 'informe_consolidado_de_ingresos_view'

  protected
    def readonly?
      true
    end
end

