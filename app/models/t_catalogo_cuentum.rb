# == Schema Information
#
# Table name: t_catalogo_cuenta
#
#  id               :bigint           not null, primary key
#  codigo           :string           not null
#  descripcion      :string           not null
#  estatus          :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  t_tipo_cuenta_id :bigint           not null
#

class TCatalogoCuentum < ApplicationRecord
	belongs_to :t_tipo_cuenta
  
	has_many :t_catalogo_cuenta_subs, dependent: :destroy
end
