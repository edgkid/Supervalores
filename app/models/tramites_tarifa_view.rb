# == Schema Information
#
# Table name: tramites_de_tarifa_view
#
#  id                 :bigint
#  cantidad           :bigint
#  fecha_notificacion :date
#  codigo             :string
#  nombre             :string
#  descripcion        :string
#  tipo               :string
#

class TramitesTarifaView < ApplicationRecord
  self.table_name = 'tramites_de_tarifa_view'

  protected
    def readonly?
      true
    end
end
