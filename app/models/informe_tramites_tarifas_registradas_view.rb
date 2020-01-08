# == Schema Information
#
# Table name: informe_presupuestario_view
#
#  id                 :bigint
#  codigo             :string
#  descripcion        :string
#  fecha_notificacion :date
#  pago_pendiente     :float
#

class InformeTramitesTarifasRegistradasView < ApplicationRecord
  self.table_name = 'informe_tramites_tarifas_registradas'

  protected
    def readonly?
      true
    end
end
