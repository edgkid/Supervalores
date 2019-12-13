# == Schema Information
#
# Table name: informe_de_recaudacion_view
#
#  id                 :bigint
#  fecha_notificacion :date
#  total_factura      :float
#  forma_pago         :string
#  identificacion     :string
#  resolucion         :string
#  razon_social       :string
#  t_recibo_id        :bigint
#  estado             :text
#

class InformeDeRecaudacionView < ApplicationRecord
  self.table_name = 'informe_de_recaudacion_view'

  protected
    def readonly?
      true
    end
end
