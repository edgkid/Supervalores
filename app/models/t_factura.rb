class TFactura < ApplicationRecord
	#belongs_to :t_cliente
  belongs_to :t_resolucion
  belongs_to :t_periodo
  belongs_to :t_estatus
  # belongs_to :t_estatus_fac
  belongs_to :t_leyenda, optional: true
  belongs_to :user

  has_many :t_factura_detalles, dependent: :destroy
  accepts_nested_attributes_for :t_factura_detalles, allow_destroy: true
  has_many :t_recibos, dependent: :destroy
  has_many :t_email_masivos, dependent: :destroy
  has_many :t_nota_creditos, dependent: :destroy
  has_many :t_estado_cuentums, dependent: :destroy
  has_many :t_clientes, through: :t_estado_cuentum
  has_many :t_recargos, dependent: :nullify

  validates :fecha_notificacion,
    presence: {
      message: "|La fecha de notificación no puede estar vacía"
    }
  validates :fecha_vencimiento,
    presence: {
      message: "|La fecha de vencimiento no puede estar vacía"
    }
  validates :t_resolucion,
    presence: {
      message: "|La resolución debe existir"
    }
  validates :t_periodo,
    presence: {
      message: "|Debe seleccionar un periodo"
    }

  def calculate_pending_payment
    self.total_factura - self.t_recibos.sum(:pago_recibido)
  end

  def calculate_total(services_total, surcharges, rates)
    total = services_total
    surcharges.each do |surcharge|
      total += (total * surcharge)
    end
    rates.each do |rate|
      total += rate
    end
    self.total_factura = total
  end
end
