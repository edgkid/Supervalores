class TConfFacAutomatica < ApplicationRecord
  belongs_to :t_tipo_cliente
  belongs_to :t_periodo

  has_many :t_factura_recargos, dependent: :destroy
  has_many :t_recargos, through: :t_factura_recargos
  
  has_many :t_factura_servicios, dependent: :destroy
  has_many :t_tarifa_servicios, through: :t_factura_servicios
  
  has_many :t_factura_tarifas, dependent: :destroy
  has_many :t_tarifas, through: :t_factura_tarifas

  validates :nombre_ciclo_facturacion, presence: {
    message: "|El nombre del ciclo de facturación no puede estar vacío"
  }
  validates :fecha_inicio, presence: {
    message: "|La fecha de inicio de facturación no puede estar vacía"
  }
  validates :t_tipo_cliente_id, presence: {
    message: "|El tipo de cliente no puede estar vacío"
  }
  validates :t_periodo_id, presence: {
    message: "|El periodo no puede estar vacío"
  }
  # validates :t_recargo_ids, presence: {
  #   message: "|Debe seleccionar al menos un recargo"
  # }
end
