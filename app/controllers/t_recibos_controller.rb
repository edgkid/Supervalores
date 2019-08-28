class TRecibosController < ApplicationController
  before_action :set_t_factura
  before_action :set_necessary_objects, only: [:new, :create]

  def new
    @t_recibo = TRecibo.new
  end

  def create
    @t_recibo = TRecibo.new(t_recibo_params)
    @t_recibo.calculate_default_attributes(@t_factura, @t_cliente, @t_periodo, current_user)

    if @t_recibo.save!
      redirect_to new_t_factura_t_recibo_path(@t_factura), notice: 'Recibo Creado exitosamente'
    else
      @notice = @t_factura.errors
      render 'new'
    end
  end

  def edit
  end

  def index
  end

  def show
  end

  private

    def set_t_factura
      @t_factura = TFactura.find(params[:t_factura_id])
    end

    def t_recibo_params
      params.require(:t_recibo).permit(
        :pago_recibido, :pago_pendiente, :justificacion, :t_metodo_pago_id
      )
    end

    def set_necessary_objects
      @t_recibos = @t_factura.t_recibos
      @pending_payment = @t_factura.calculate_pending_payment

      @t_resolucion = @t_factura.t_resolucion
      @t_periodo = @t_factura.t_periodo
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
