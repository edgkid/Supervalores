module TMetodoPagosHelper
  def payment_method_options
    TMetodoPago.where(estatus: 1).pluck(:forma_pago, :id)
  end
end
