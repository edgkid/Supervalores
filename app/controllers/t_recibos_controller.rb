class TRecibosController < ApplicationController
  before_action :set_t_factura, except: :index
  before_action :set_t_recibo, only: :destroy
  before_action :set_necessary_objects, only: [:new, :create, :show]

  def new
    @t_recibo = TRecibo.new
  end

  def create
    @t_recibo = TRecibo.new(t_recibo_params)
    @t_recibo.calculate_default_attributes(@t_factura, @t_cliente, current_user)

    if @t_recibo.save
      redirect_to new_t_factura_t_recibo_path(@t_factura), notice: 'Recibo Creado exitosamente'
    else
      @notice = @t_recibo.errors
      render 'new'
    end
  end

  def edit
  end

  def index
    @usar_dataTables = true
    @attributes_to_display = [
      :id, :fecha_pago, :t_metodo_pago, :justificacion,
      :pago_recibido, :pago_pendiente, :monto_acreditado
    ]

    respond_to do |format|
      format.html
      format.json { render json: TReciboDatatable.new(
        params.merge({
          attributes_to_display: @attributes_to_display,
          parent_resource: 't_factura'
        }),
        view_context: view_context)
      }
    end
  end

  def show
    @is_show = true
    @t_recibo = TRecibo.find(params[:id])
  end

  def destroy
    @t_recibo.destroy

    redirect_to t_factura_t_recibos_path(@t_factura)
  end

  private

    def set_t_factura
      @t_factura = TFactura.find(params[:t_factura_id])
    end

    def set_t_recibo
      @t_recibo = TRecibo.find(params[:id])
    end

    def t_recibo_params
      params.require(:t_recibo).permit(
        :pago_recibido, :pago_pendiente, :justificacion, :num_cheque, :t_metodo_pago_id
      )
    end

    def set_necessary_objects
      @t_recibos = @t_factura.t_recibos
      @pending_payment = @t_factura.calculate_pending_payment

      @t_resolucion = @t_factura.t_resolucion
      @t_tarifa  = @t_resolucion.t_tipo_cliente.t_tarifa
      @t_estatus = @t_factura.t_estatus
      @t_cliente = @t_resolucion.t_cliente
      @t_persona = @t_cliente.persona
      if @t_persona.class.to_s == 'TEmpresa'
        @t_empresa = @t_persona
        @t_persona = nil
      else
        @t_empresa = @t_persona.t_empresa
      end
    end
end
