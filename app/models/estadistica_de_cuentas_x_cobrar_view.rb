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

class EstadisticaDeCuentasXCobrarView < ApplicationRecord
  self.table_name = 'estadistica_cuentas_x_cobrar'

  protected
    def readonly?
      true
    end
end
