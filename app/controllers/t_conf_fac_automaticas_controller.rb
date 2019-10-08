class TConfFacAutomaticasController < ApplicationController
  before_action :set_t_conf_fac_automatica, only: [:show, :edit, :update]

  def new
    # @do_not_use_plain_select2 = true
    @no_cache = true
    @t_conf_fac_automatica = TConfFacAutomatica.new
  end

  def create
    @t_conf_fac_automatica = TConfFacAutomatica.new(t_conf_fac_automatica_params)
    @t_conf_fac_automatica.user = current_user

    if @t_conf_fac_automatica.save
      @t_conf_fac_automatica.schedule_invoices

      redirect_to t_conf_fac_automaticas_path, notice: 'Configuración de Factura creada exitosamente'
    else
      @notice = @t_conf_fac_automatica.errors
      render 'new'
    end
  end

  def edit
  end

  def update
    @t_conf_fac_automatica.user = current_user
    
    if @t_conf_fac_automatica.update(t_conf_fac_automatica_params)
      @t_conf_fac_automatica.terminar_tareas_actuales()
      @t_conf_fac_automatica.schedule_invoices

      redirect_to t_conf_fac_automaticas_path, notice: 'Configuración de Factura actualizada exitosamente'
    else
      @notice = @t_conf_fac_automatica.errors
      render 'edit'
    end
  end

  def index
    @usar_dataTables = true
    @attributes_to_display = [
      :id, :nombre_ciclo_facturacion, :t_periodo,
      :fecha_inicio, :t_tipo_cliente
    ]

    respond_to do |format|
      format.html
      format.json { render json: TConfFacAutomaticaDatatable.new(
        params.merge({
          attributes_to_display: @attributes_to_display
        }),
        view_context: view_context)
      }
    end
  end

  def show
    @t_tarifa_servicios = @t_conf_fac_automatica.t_tarifa_servicios
    @t_recargos = @t_conf_fac_automatica.t_recargos
    @t_tarifas = @t_conf_fac_automatica.t_tarifas
  end

  def destroy
    @t_conf_fac_automatica = TConfFacAutomatica.find(params[:id])
    @t_conf_fac_automatica.terminar_tareas_actuales()
    @t_conf_fac_automatica.destroy

    redirect_to t_conf_fac_automaticas_path, notice: 'Configuración de Factura eliminada exitosamente'
  end

  private

    def t_conf_fac_automatica_params
      params.require(:t_conf_fac_automatica).permit(
        :nombre_ciclo_facturacion, :fecha_inicio, :estatus,
        :t_tipo_cliente_id, :t_periodo_id,
        {t_tarifa_servicio_ids: []}, {t_recargo_ids: []}, {t_tarifa_ids: []}
      )
    end

    def set_t_conf_fac_automatica
      @t_conf_fac_automatica = TConfFacAutomatica.find(params[:id])
    end
end
