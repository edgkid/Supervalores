class TTarifaServicio < ApplicationRecord
  has_many :t_factura_detalles, dependent: :destroy
  has_many :t_estado_cuenta_conts, dependent: :destroy
end
