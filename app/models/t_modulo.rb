# == Schema Information
#
# Table name: t_modulos
#
#  id          :bigint           not null, primary key
#  nombre      :string
#  descripcion :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  alias       :string
#

class TModulo < ApplicationRecord
  has_many :t_modulo_rols, dependent: :destroy

  # Código para obtener una lista de todas las tablas existentes de la base de datos
  # ActiveRecord::Base.connection.tables.map do |model|
  #   model.capitalize.singularize.camelize
  # end

  MODULOS = [
    "TTipoCuentum",
    "TCatalogoCuentum",
    "TCatalogoCuentaSub",
    "TPresupuesto",
    "TTipoPersona",
    "TTipoCliente",
    "TTarifa",
    "TCuentaVentum",
    "TTipoEmision",
    "TResolucion",
    "TRecargoXCliente",
    "TRecargo",
    "TMetodoPago",
    "TPeriodo",
    "TLeyenda",
    "TTarifaServicioGroup",
    "TCuentaFinanciera",
    "TTarifasPeriodo",
    "TFactura",
    "TFacturaDetalle",
    "TTarifaServicio",
    "TRecibo",
    "TCaja",
    "TEstadoCuentum",
    "TEstadoCuentaCont",
    "TEmision",
    "TEmailMasivo",
    "TNotaCredito",
    "TClienteTarifa",
    "TEstatus",
    "TEmpresa",
    "TCliente",
    "TPersona",
    "TEmpresaTipoValor",
    "TOtro",
    "User",
    "TEmpresaSectorEconomico",
    "TTipoClienteTipo",
    "TContacto",
    "TConfFacAutomatica",
    "TRol",
    "TModulo",
    "TPermiso",
    "TConfiguracionRecargoT"
  ]
end
