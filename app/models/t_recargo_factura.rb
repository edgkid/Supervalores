# == Schema Information
#
# Table name: t_recargo_facturas
#
#  id           :bigint           not null, primary key
#  t_recargo_id :bigint
#  t_factura_id :bigint
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

# Esta clase la usa el modelo TFactura
class TRecargoFactura < ApplicationRecord
  belongs_to :t_recargo
  belongs_to :t_factura
end
