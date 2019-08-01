class TRecibo < ApplicationRecord

	blongs_to :t_factura
    blongs_to :t_cliente
    blongs_to :t_periodo
    blongs_to :t_metodo_pago
    blongs_to :user

    #has_many :t_recibo_detalle
    has_many :t_caja
    has_many :t_nota_credito

    has_many :t_estado_cuentum
    has_many :t_cliente, through: :t_estado_cuentum
    
end
