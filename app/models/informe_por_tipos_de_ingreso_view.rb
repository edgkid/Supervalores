# == Schema Information
#
# Table name: informe_por_tipos_de_ingreso_view
#
#  id             :bigint
#  codigo         :string
#  forma_pago     :string
#  total_factura  :float
#  t_recibo_id    :bigint
#  razon_social   :string
#  pago_pendiente :float
#  fecha_pago     :date
#  estado         :text
#

class InformePorTiposDeIngresoView < ApplicationRecord
  self.table_name = 'informe_por_tipos_de_ingreso_view'

  protected
    def readonly?
      true
    end
end
