class TEmision < ApplicationRecord
	#belongs_to :t_cliente
  belongs_to :t_periodo
  belongs_to :t_tipo_emision
  belongs_to :user
  
  # :fecha_emision,
  # :valor_circulacion,
  # :tasa,
  # :monto_pagar,
  # :estatus,
  # :t_periodo_id,
  # :t_tipo_emision_id,
  # :user_id


end
