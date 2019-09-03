class Automaticas::TFacturasController < ApplicationController
  # before_action :set_t_factura, only: [:edit, :update, :preview, :show, :destroy]

  def new
    # @do_not_use_plain_select2 = true
    @t_factura = TFactura.new
    @t_factura.t_factura_detalles.build
  end

  def index
    @t_facturas = TFactura.where(automatica: true)
    @title = 'Facturas Automáticas'
    @add_invoice_path = new_automaticas_t_factura_path
  end

  private

    def set_t_factura
      @t_factura = TFactura.find(params[:id])
    end
end
