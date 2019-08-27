class TRecibo < ApplicationRecord
	belongs_to :t_factura
  belongs_to :t_cliente
  belongs_to :t_periodo
  belongs_to :t_metodo_pago
  belongs_to :user

  #has_many :t_recibo_detalle
  has_many :t_cajas, dependent: :destroy
  has_many :t_nota_creditos, dependent: :destroy

  has_many :t_estado_cuentums, dependent: :destroy
  has_many :t_clientes, through: :t_estado_cuentum

  def calculate_default_attributes(t_factura, t_cliente, t_periodo, current_user)
    remaining = t_factura.calculate_pending_payment - self.pago_recibido
    credited_amount = remaining < 0 ? (remaining * (-1)) : 0
    pending_payment = remaining > 0 ? remaining : 0

    debugger

    self.monto_acreditado = credited_amount
    self.pago_pendiente = pending_payment
    self.fecha_pago = Date.today
    self.t_factura = t_factura
    self.t_cliente = t_cliente
    self.t_periodo = t_periodo
    self.t_metodo_pago = TMetodoPago.first
    self.estatus = 1
    self.user = current_user
  end
end
