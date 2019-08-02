class TEmision < ApplicationRecord
	#belongs_to :t_cliente
  belongs_to :t_periodo
  belongs_to :t_tipo_emision
  belongs_to :user
end
