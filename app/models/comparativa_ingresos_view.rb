# == Schema Information
#
# Table name: comparativa_ingresos_view
#
#  id                   :bigint
#  t_factura_id         :bigint
#  t_cliente_id         :bigint
#  t_tarifa_servicio_id :bigint
#  fecha_pago           :date
#  pago_recibido        :float
#  detalle_factura      :string
#  nombre_servicio      :string
#  descripcion_servicio :string
#  identificacion       :string
#  razon_social         :string
#

class ComparativaIngresosView < ApplicationRecord
  self.table_name = 'comparativa_ingresos_view'

  protected
    def readonly?
      true
    end
end
