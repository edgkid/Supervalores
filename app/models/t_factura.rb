class TFactura < ApplicationRecord
	#belongs_to :t_cliente
  belongs_to :t_resolucion
  belongs_to :t_periodo
  belongs_to :t_estatus_fac
  belongs_to :t_leyenda 
  belongs_to :t_usuario

  has_many :t_factura_detalles, dependent: :destroy
  has_many :t_recibos, dependent: :destroy
  has_many :t_email_masivos, dependent: :destroy
  has_many :t_nota_creditos, dependent: :destroy
  has_many :t_estado_cuentums, dependent: :destroy
  has_many :t_clientes, through: :t_estado_cuentum
  has_many :t_recargos, dependent: :nullify
end
