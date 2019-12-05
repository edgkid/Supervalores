# == Schema Information
#
# Table name: t_leyendas
#
#  id          :bigint           not null, primary key
#  anio        :integer
#  descripcion :string
#  estatus     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class TLeyenda < ApplicationRecord
	has_many :t_facturas, dependent: :destroy
end
