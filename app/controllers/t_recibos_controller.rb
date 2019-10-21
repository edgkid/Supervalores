class TRecibosController < ApplicationController
  before_action :set_t_factura, except: :index
  before_action :set_preview_data, only: :new
  before_action :set_t_recibo, only: [:show, :destroy, :generar_pdf]
  before_action :set_necessary_objects, only: [:new, :create, :show]

  def new
    @last_t_recibo = TRecibo.find(params[:recibo_id]) if params[:recibo_id]
    # generar_pdf(target) if params[:show_pdf] == "true"
    @t_recibo = TRecibo.new
  end

  def create
    @t_recibo = TRecibo.new(t_recibo_params)
    @t_recibo.set_surcharge_and_services_total(@t_recibo.pago_recibido || 0, @t_factura, @t_factura.t_recibos.empty?)
    @t_recibo.calculate_default_attributes(@t_factura, @t_cliente, current_user)
    if @t_recibo.save
      # generar_pdf
      redirect_to new_t_factura_t_recibo_path(@t_factura, show_pdf: true, recibo_id: @t_recibo.id), notice: 'Recibo creado exitosamente'
    else
      @notice = @t_recibo.errors
      set_preview_data
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
  end

  def destroy
    @t_recibo.destroy

    redirect_to t_factura_t_recibos_path(@t_factura)
  end

  def generar_pdf
    pdf = TReciboPdf.new(@t_factura, @t_recibo, current_user.id)
    send_data(
      pdf.render,
      filename: "recibo_nro_#{@t_recibo.id}.pdf",
      type: "application/pdf",
      disposition: "inline"
    ) and return
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
        :pago_recibido, :justificacion, :num_cheque, :t_metodo_pago_id
      )
    end

    def set_preview_data
      @t_resolucion = @t_factura.t_resolucion
      @t_tarifa  = @t_resolucion.t_tipo_cliente.t_tarifa
      @t_periodo = @t_factura.t_periodo
      @t_estatus = @t_factura.t_estatus
      @t_cliente = @t_resolucion.t_cliente

      @t_empresa = @t_cliente.persona.try(:rif)            ? @t_cliente.persona : nil
      @t_persona = @t_cliente.persona.try(:cedula)         ? @t_cliente.persona : nil
      @t_otro    = @t_cliente.persona.try(:identificacion) ? @t_cliente.persona : nil
    end

    def set_necessary_objects
      @t_recibos = @t_factura.t_recibos
      if @t_recibos.any?
        @pending_payment = @t_recibos.last.pago_pendiente.truncate(2)
      else
        @pending_payment = @t_factura.calculate_pending_payment.truncate(2)
      end

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
