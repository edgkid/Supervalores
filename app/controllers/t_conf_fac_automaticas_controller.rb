class TConfFacAutomaticasController < ApplicationController
  before_action :set_t_factura, only: :show

  def new
    # @do_not_use_plain_select2 = true
    @no_cache = true
    @t_conf_fac_automatica = TConfFacAutomatica.new
  end

  def create
    @t_conf_fac_automatica = TConfFacAutomatica.new(t_factura_params)

    if @t_conf_fac_automatica.save
      redirect_to t_conf_fac_automaticas_path
    else
      @notice = @t_conf_fac_automatica.errors
      render 'new'
    end
  end

  def index
    @usar_dataTables = true
    @t_conf_fac_automaticas = TConfFacAutomatica.all
  end

  def show
    @t_tarifa_servicios = @t_conf_fac_automatica.t_tarifa_servicios
    @t_recargos = @t_conf_fac_automatica.t_recargos
    @t_tarifas = @t_conf_fac_automatica.t_tarifas
  end

  private

    def t_factura_params
      params.require(:t_conf_fac_automatica).permit(
        :nombre_ciclo_facturacion, :fecha_inicio, :t_tipo_cliente_id, :t_periodo_id,
        {t_tarifa_servicio_ids: []}, {t_recargo_ids: []}, {t_tarifa_ids: []}
      )
    end

    def set_t_factura
      @t_conf_fac_automatica = TConfFacAutomatica.find(params[:id])
    end
end
