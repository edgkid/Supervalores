# == Schema Information
#
# Table name: t_tarifa_servicios
#
#  id          :bigint           not null, primary key
#  codigo      :string           not null
#  descripcion :string           not null
#  nombre      :string           not null
#  clase       :string           not null
#  precio      :float            not null
#  estatus     :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  tipo        :string
#

class TTarifaServicio < ApplicationRecord
  has_many :t_factura_detalles, dependent: :destroy
  has_many :t_estado_cuenta_conts, dependent: :destroy
end
