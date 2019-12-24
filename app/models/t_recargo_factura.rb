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

  validates :t_recargo_id, presence: {
    message: "|El recargo debe estar asociado a la factura."
  }
  validates :cantidad, presence: {
    message: "|Debe indicar una cantidad de recargos."
  }
  validates :precio_unitario, presence: {
    message: "|Debe indicar el precio del recargo."
  }
end
