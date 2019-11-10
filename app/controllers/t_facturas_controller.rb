class TFacturasController < ApplicationController
  before_action :set_t_factura, only: [:edit, :update, :preview, :show, :destroy, :generar_pdf]
  before_action :set_dynamic_attributes, only: [:edit]
  load_and_authorize_resource

  def new
    @do_not_use_plain_select2 = true
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
    @t_factura.recargo = @t_factura.calculate_total_surcharge(true)
    @t_factura.recargo_desc = '-'
    @t_factura.itbms = 0
    @t_factura.importe_total = 0
    @t_factura.pendiente_fact = @t_factura.calculate_pending_payment
    @t_factura.pendiente_ts = 0
    @t_factura.tipo = '-'
    @t_factura.next_fecha_recargo = Date.today + 1.month
    @t_factura.monto_emision = 0
    @t_factura.t_estatus = TEstatus.find_by(descripcion: 'Disponible') || TEstatus.first

    ced_pas_ruc = params[:dynamic_attributes][:t_cliente][:cedula]
    t_empresa = TEmpresa.find_by(rif: ced_pas_ruc)
    t_persona = TPersona.find_by(cedula: ced_pas_ruc)
    t_otro = TOtro.find_by(identificacion: ced_pas_ruc)

    @t_factura.t_cliente = t_empresa.try(:t_cliente) || t_persona.try(:t_cliente) || t_otro.try(:t_cliente)

    if @t_factura.save
      t_factura_detalles = @t_factura.t_factura_detalles
      if t_factura_detalles.any? && t_factura_detalles.first.t_tarifa_servicio.tipo && t_factura_detalles.first.t_tarifa_servicio.tipo.downcase == 'ts'
        @t_factura.apply_2_percent_monthly_surcharge
      end
      redirect_to new_t_factura_t_recibo_path(@t_factura), notice: 'Factura creada exitosamente.'
    else
      @notice = @t_factura.errors
      @notice.messages[:t_resolucion] -= [@notice.messages[:t_resolucion].first]
      @do_not_use_plain_select2 = true
      render 'new', params[:dynamic_attributes]
    end
  end

  def preview
    @t_resolucion = @t_factura.t_resolucion
    # @t_tarifa  = @t_resolucion.t_tipo_cliente.t_tarifa
    @t_periodo = @t_factura.t_periodo
    @t_estatus = @t_factura.t_estatus
    @t_cliente = @t_resolucion.try(:t_cliente) || @t_factura.try(:t_cliente)

    @t_empresa = @t_cliente.persona.try(:rif)            ? @t_cliente.persona : nil
    @t_persona = @t_cliente.persona.try(:cedula)         ? @t_cliente.persona : nil
    @t_otro    = @t_cliente.persona.try(:identificacion) ? @t_cliente.persona : nil
  end

  def edit
    @do_not_use_plain_select2 = true
    @no_cache = true    
  end

  def update
    if @t_factura.update(t_factura_params)
      redirect_to t_facturas_path
    else
      @notice = @t_factura.errors
      @do_not_use_plain_select2 = true
      render 'edit', params[:dynamic_attributes]
    end
  end

  def index
    @usar_dataTables = true
    @attributes_to_display = [
      :id, :t_cliente, :resolucion, :fecha_notificacion, :fecha_vencimiento,
      :recargo, :total_factura, :pendiente_fact
    ]

    respond_to do |format|
      format.html
      format.json { render json: TFacturaDatatable.new(
        params.merge({
          attributes_to_display: @attributes_to_display,
          automatica: params[:automatica]
        }),
        view_context: view_context)
      }
    end
  end

  def show
  end

  def destroy
    @t_factura.destroy
    redirect_to t_facturas_path, notice: 'Factura eliminada exitosamente'
  end

  def generar_pdf
    pdf = TFacturaPdf.new(@t_factura)
    send_data(
      pdf.render,
      filename: "factura_nro_#{@t_factura.id}.pdf",
      type: "application/pdf",
      disposition: "inline"
    ) and return
  end

  def pagadas
    @usar_dataTables = true
    @do_not_use_plain_select2 = true
    @no_cache = true

    @attributes_to_display = [
      :id, :razon_social, :resolucion, :fecha_notificacion, :fecha_vencimiento,
      :recargo, :total_factura
    ]

    respond_to do |format|
      format.html
      format.json { render json: TFacturaPagadaDatatable.new(
        params.merge({
          attributes_to_display: @attributes_to_display
        }),
        view_context: view_context)
      }
    end
  end

  def total_pagadas
    dataTable =  TFacturaPagadaDatatable.new(
      params.merge({
        attributes_to_display: @attributes_to_display
      }),
      view_context: view_context
    )
    total = dataTable.get_raw_records.count
    results = {
      procesado: true,
      total: total
    }
    render json: results
  end

  def informe_recaudacion
    @usar_dataTables = true
    @do_not_use_plain_select2 = true
    @no_cache = true

    @attributes_to_display = [
      :factura_id, :recibo_id, :razon_social, :res, :identificacion,
      :fecha_notificacion, :forma_pago, :estado, :total_factura
    ]

    respond_to do |format|
      format.html
      format.json { render json: InformeDeRecaudacionDatatable.new(
        params.merge({
          attributes_to_display: @attributes_to_display
        }),
        view_context: view_context)
      }
    end
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

    def set_dynamic_attributes
      t_resolucion = @t_factura.t_resolucion
      t_cliente    = t_resolucion.t_cliente
      t_empresa    = t_cliente.persona.try(:rif)            ? t_cliente.persona : nil
      t_persona    = t_cliente.persona.try(:cedula)         ? t_cliente.persona : nil
      t_otro       = t_cliente.persona.try(:identificacion) ? t_cliente.persona : nil

      t_factura_detalles = @t_factura.t_factura_detalles
      t_tarifa_servicios = []
      t_tarifa_servicio_ids = []
      t_tarifa_servicio_descripcions = []
      t_tarifa_servicio_quantities = []
      t_tarifa_servicio_prices = []
      t_factura_detalles.each do |fd|
        t_tarifa_servicios << fd.t_tarifa_servicio.nombre
        t_tarifa_servicio_ids << fd.t_tarifa_servicio.id
        t_tarifa_servicio_descripcions << fd.t_tarifa_servicio.descripcion
        t_tarifa_servicio_quantities << fd.cantidad
        t_tarifa_servicio_prices << fd.precio_unitario
      end

      t_recargos = @t_factura.t_recargos
      t_recargo_descripcions = []
      t_recargo_ids = []
      t_recargo_quantities = []
      t_recargo_prices = []
      t_recargos.each do |r|
        t_recargo_descripcions << r.descripcion
        t_recargo_ids << r.id
        t_recargo_quantities << 1
        t_recargo_prices << r.tasa
      end

      params.merge!(ActionController::Parameters.new(
        dynamic_attributes: {
          t_cliente: {
            codigo_select: t_cliente.codigo,
            cedula: t_persona.try(:cedula) || t_empresa.try(:rif) || t_otro.try(:identificacion),
            resolucion: t_resolucion.resolucion,
            resolucion_id: t_resolucion.id,
            estatus: 1,
            codigo: t_cliente.codigo,
            empresa: t_empresa.try(:rif),
            direccion: t_empresa.try(:direccion_empresa),
            telefono: t_empresa.try(:telefono)
          },
          t_tarifa_servicio: {
            names: t_tarifa_servicios,
            ids: t_tarifa_servicio_ids,
            descripcions: t_tarifa_servicio_descripcions,
            quantities: t_tarifa_servicio_quantities,
            prices: t_tarifa_servicio_prices
          },
          t_recargo: {
            descripcions: t_recargo_descripcions,
            ids: t_recargo_ids,
            quantities: t_recargo_quantities,
            prices: t_recargo_prices
          }
        }
      ).permit!)
    end
end
