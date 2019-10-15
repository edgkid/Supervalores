class TRecibo < ApplicationRecord
	belongs_to :t_factura
  belongs_to :t_cliente
  belongs_to :t_periodo, optional: true
  belongs_to :t_metodo_pago
  belongs_to :user

  #has_many :t_recibo_detalle
  has_many :t_cajas, dependent: :destroy
  has_many :t_nota_creditos, dependent: :destroy

  has_many :t_estado_cuenta, dependent: :destroy
  has_many :t_clientes, through: :t_estado_cuentum

  validates :pago_recibido, numericality: {
    message: "|El monto pagado debe ser un número válido."
  }
  validates :num_cheque, presence: {
    message: "|El número de cheque no debe estar en blanco.",
    if: :is_check
  }

  def is_check
    self.t_metodo_pago == TMetodoPago.find_by(forma_pago: 'Cheque') || TMetodoPago.find_by(forma_pago: 'cheque')
  end

  def calculate_default_attributes(t_factura, t_cliente, current_user)
    remaining = t_factura.calculate_pending_payment - (self.pago_recibido || 0)
    credited_amount = remaining < 0 ? (remaining * (-1)) : 0
    pending_payment = remaining > 0 ? remaining : 0

    self.monto_acreditado = credited_amount
    self.pago_pendiente = pending_payment
    self.fecha_pago = Date.today
    self.t_factura = t_factura
    self.t_cliente = t_cliente
    self.estatus = 1
    self.user = current_user
  end

  def self.count_paid_receipts_by_month(month_number)
    TRecibo.where(
      'extract(month from created_at) = ?
      AND pago_pendiente <= ?',
      month_number,
      0
    ).count
  end

  def self.count_paid_receipts_by_months(number_of_months)
    older_month = (Date.today - number_of_months.months).month
    paid_receipts_list = []

    (older_month..Date.today.month).each do |month_number|
      paid_receipts_list << TRecibo.count_paid_receipts_by_month(month_number)
    end

    paid_receipts_list
  end
end
