class TFactura < ApplicationRecord

	#belongs_to :t_cliente
    belongs_to :t_resolucion
    belongs_to :t_periodo
    belongs_to :t_estatus_fac
    belongs_to :t_leyenda 
    belongs_to :t_usuario

    has_many :t_factura_detalle
    has_many :t_recibo
    has_many :t_email_masivo
    has_many :t_nota_credio

    has_many :t_estado_cuentum
    has_many :t_cliente, through: :t_estado_cuentum

end
