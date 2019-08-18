class TFacturasController < ApplicationController
  before_action :set_t_factura, only: [:edit, :update, :preview, :show, :destroy]

  load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
		redirect_to dashboard_access_denied_path, :alert => exception.message
	end

  def new
    @t_factura = TFactura.new
    # @t_factura.t_factura_detalles.build
    @t_recargos = TRecargo.all
    @t_clientes = TCliente.first(10)
    @t_resolucions = TResolucion.first(10)
    @no_cache = true
  end

  def create
    @t_factura = TFactura.new(t_factura_params)
    @t_factura.user = current_user
    @t_factura.recargo = 0
    @t_factura.recargo_desc = '-'
    @t_factura.itbms = 0
    @t_factura.importe_total = 0
    @t_factura.pendiente_fact = 0
    @t_factura.pendiente_ts = 0
    @t_factura.tipo = '-'
    @t_factura.next_fecha_recargo = Date.today
    @t_factura.monto_emision = 0
    @t_factura.t_estatus_id = TEstatus.first.id

    if @t_factura.save
      redirect_to preview_t_factura_path(@t_factura), notice: 'Factura creada exitosamente.'
    else
      @notice = @t_factura.errors
      @notice.messages[:t_resolucion] -= [@notice.messages[:t_resolucion].first]
      @notice.messages[:t_periodo] -= [@notice.messages[:t_periodo].first]
      render 'new'
    end
  end

  def preview
    @t_resolucion = @t_factura.t_resolucion
    @t_periodo = @t_factura.t_periodo
    @t_estatus = @t_factura.t_estatus
    @t_cliente = @t_resolucion.t_cliente
    @t_persona = @t_cliente.persona
    @t_empresa = @t_persona.t_empresa
  end

  def edit
  end

  def update
    if @t_factura.update(t_factura_params)
      # flash[:success] = "Factura actualizado exitosamente."
      redirect_to t_facturas_path
    else
      # flash.now[:danger] = "No se pudo modificar el factura."
      render 'edit'
    end
  end

  def index
    @usar_dataTables = true
    @t_facturas = TFactura.all
  end

  def show
  end

  def destroy
    @t_factura.destroy

    # flash[:warning] = "Factura eliminado."
    redirect_to t_facturas_path
  end

  private

    def t_factura_params
      params.require(:t_factura).permit(
        :fecha_notificacion, :fecha_vencimiento, :recargo_desc,
        :t_resolucion_id, :t_periodo_id, :total_factura, {t_recargo_ids: []},
        t_factura_detalles_attributes: [
          :id, :cantidad, :cuenta_desc, :_destroy,
          :precio_unitario, :t_tarifa_servicio_id
        ]
      )
    end

    def set_t_factura
      @t_factura = TFactura.find(params[:id])
    end
end
