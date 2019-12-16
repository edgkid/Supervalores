# == Schema Information
#
# Table name: informe_de_clientes_view
#
#  id                 :bigint
#  identificacion     :string
#  razon_social       :string
#  fecha_notificacion :date
#  fecha_vencimiento  :date
#  t_resolucion_id    :bigint
#  resolucion         :string
#  t_factura_id       :bigint
#  recargo            :float
#  total_factura      :float
#  t_tipo_cliente_id  :bigint
#

class InformeDeClientesView < ApplicationRecord
  self.table_name = 'informe_de_clientes_view'

  protected
    def readonly?
      true
    end
end
