# == Schema Information
#
# Table name: t_tipo_emisions
#
#  id          :bigint           not null, primary key
#  descripcion :string
#  estatus     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class TTipoEmision < ApplicationRecord
	#has_many :t_cliente
	has_many :t_emisions, dependent: :destroy
end
