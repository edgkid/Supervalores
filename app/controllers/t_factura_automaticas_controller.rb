class TFacturaAutomaticasController < ApplicationController
  before_action :set_t_factura, only: :show

  def new
    # @do_not_use_plain_select2 = true
    @no_cache = true
    @t_factura_automatica = TFacturaAutomatica.new
  end

  def create
    @t_factura_automatica = TFacturaAutomatica.new(t_factura_params)

    if @t_factura_automatica.save
      redirect_to t_factura_automaticas_path
    else
      @notice = @t_factura_automatica.errors
      render 'new'
    end
  end

  def index
    @usar_dataTables = true
    @t_factura_automaticas = TFacturaAutomatica.all
  end

  def show
    @t_tarifa_servicios = @t_factura_automatica.t_tarifa_servicios
    @t_recargos = @t_factura_automatica.t_recargos
    @t_tarifas = @t_factura_automatica.t_tarifas
  end

  private

    def t_factura_params
      params.require(:t_factura_automatica).permit(
        :nombre_ciclo_facturacion, :fecha_inicio, :t_tipo_cliente_id, :t_periodo_id,
        {t_tarifa_servicio_ids: []}, {t_recargo_ids: []}, {t_tarifa_ids: []}
      )
    end

    def set_t_factura
      @t_factura_automatica = TFacturaAutomatica.find(params[:id])
    end
end
