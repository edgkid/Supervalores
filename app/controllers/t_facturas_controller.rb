class TFacturasController < ApplicationController
  before_action :set_t_factura, only: [:edit, :update, :preview, :show, :destroy, :generar_pdf]
  before_action :set_dynamic_attributes, only: [:edit]
  load_and_authorize_resource except: [
    :pagadas, :informe_recaudacion, :informe_ingresos_diarios, :informe_ingresos_presupuesto,
    :informe_cuentas_x_cobrar, :informe_presupuestario, :informe_por_tipos_de_ingreso,
    :recaudacion_total, :total_pagadas, :total_cuentas_x_cobrar]
  before_action :authorize_user_to_read_reports, only: [
    :pagadas, :informe_recaudacion, :informe_ingresos_diarios, :informe_ingresos_presupuesto,
    :informe_cuentas_x_cobrar, :informe_presupuestario, :informe_por_tipos_de_ingreso]

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
    @t_factura.recargo_desc = '-'
    @t_factura.itbms = 0
    @t_factura.importe_total = 0
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

    @t_factura.t_factura_detalles.empty? ? invalid_t_factura = true : invalid_t_factura = false

    invalid_t_recargo = false
    params[:t_recargo_facturas_attributes].each do |t_recargo_factura_param|
      t_recargo_factura = @t_factura.t_recargo_facturas.build(
        cantidad: t_recargo_factura_param[:cantidad],
        precio_unitario: t_recargo_factura_param[:precio_unitario],
        t_recargo_id: t_recargo_factura_param[:id]
      )
      invalid_t_recargo = true if t_recargo_factura.invalid?
    end if params[:t_recargo_facturas_attributes]

    @t_factura.recargo = @t_factura.calculate_total_surcharge unless invalid_t_recargo
    @t_factura.pendiente_fact = @t_factura.calculate_pending_payment unless invalid_t_recargo

    if !@t_factura.t_cliente
      if !@t_factura.t_resolucion
        without_client = true
      end
    end

    if !invalid_t_factura && !invalid_t_recargo && @t_factura.save
      t_factura_detalles = @t_factura.t_factura_detalles
      if t_factura_detalles.any? && t_factura_detalles.first.t_tarifa_servicio.tipo && t_factura_detalles.first.t_tarifa_servicio.tipo.downcase == 'ts'
        @t_factura.apply_custom_percent_monthly_surcharge(TConfiguracionRecargoT.take.try(:tasa) || 0)
      end
      #Condicion para aplicar nota de  crédito
      if @t_factura.es_ts?
        @t_nota_credito = @t_factura.t_resolucion.t_cliente.t_nota_creditos.where(status: "Sin Usar").order("created_at ASC").first
        # @t_nota_credito = @t_factura.t_cliente.t_nota_creditos.where(status:"Sin Usar").first
        unless @t_nota_credito.nil?
          @t_nota_credito.t_factura_id = @t_factura.id
          @t_nota_credito.status = "Usada"
          #Si la nota de crédito excede la factura se crea una nueva nota de crédito con la diferencia
          if @t_factura.total_factura - @t_nota_credito.monto < 0
              new_nota_credito = TNotaCredito.new
              new_nota_credito.t_cliente_id = @t_nota_credito.t_cliente_id
              new_nota_credito.t_recibo_id = @t_nota_credito.t_recibo_id
              new_nota_credito.monto = (@t_factura.total_factura - @t_nota_credito.monto).abs
              new_nota_credito.monto_original = @t_nota_credito.monto_original
              new_nota_credito.status = "Sin Usar"
              new_nota_credito.save!
              #Si la factura fue pagada en su totalidad con la nota de crédito, se actualiza el valor de la nota de crédito actual para que el excente quede reflejado en la nueva
              @t_nota_credito.monto = @t_factura.total_factura
          end
          @t_nota_credito.save!
        end
      end
      redirect_to new_t_factura_t_recibo_path(@t_factura), notice: 'Factura creada exitosamente.'
    else
      @notice = @t_factura.errors
      @notice.messages[:t_resolucion] -= [@notice.messages[:t_resolucion].first]
      if invalid_t_factura
        @notice.messages[:t_factura] << '|Debe agregar al menos un servicio'
      end
      if invalid_t_recargo
        @notice.messages[:t_factura] << '|El recargo no es válido'
      end
      if without_client
        @notice.messages[:t_factura] << '|Debe seleccionar un cliente'
      end
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
    old_t_factura = @t_factura.dup
    if @t_factura.update(t_factura_params)
      params[:services_to_destroy].each do |t_tarifa_servicio_id|
        @t_factura.t_factura_detalles.find_by(t_tarifa_servicio_id: t_tarifa_servicio_id).try(:destroy)
      end if !params[:services_to_destroy].blank?
      @t_factura.t_recargo_ids - params[:surcharges_to_destroy].map {|id| id.to_i} if !params[:surcharges_to_destroy].blank?

      @t_factura.update_receipts(old_t_factura)

      # redirect_to t_facturas_path 
      redirect_to preview_t_factura_path(@t_factura)
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
    #Si las facturas tienen recibos, es decir si no están vacías no se debe permitir borrar
    unless @t_factura.t_recibos.empty?
      redirect_to preview_t_factura_path(@t_factura), notice: 'No se puede borrar una factura que tenga recibos asociados'
      return
    end
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
    @useDataTableFooter = true
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

  def recaudacion_total
    t_facturas =
      if !params[:day].blank?
        InformeDeRecaudacionView.where(fecha_notificacion: params[:day])
      elsif !params[:ztart].blank? && !params[:end].blank?
        InformeDeRecaudacionView.where('fecha_notificacion BETWEEN ? AND ?', params[:ztart], params[:end])
      elsif !params[:month_year].blank?
        InformeDeRecaudacionView.where('fecha_notificacion BETWEEN ? AND ?',
          params[:month_year], params[:month_year].to_date.at_end_of_month.strftime('%d/%m/%Y'))
      elsif !params[:bimonthly].blank?
        InformeDeRecaudacionView.where('fecha_notificacion BETWEEN ? AND ?',
          params[:bimonthly], (params[:bimonthly].to_date + 1.month).at_end_of_month.strftime('%d/%m/%Y'))
      elsif !params[:quarterly].blank?
        InformeDeRecaudacionView.where('fecha_notificacion BETWEEN ? AND ?',
          params[:quarterly], (params[:quarterly].to_date + 2.months).at_end_of_month.strftime('%d/%m/%Y'))
      elsif !params[:biannual].blank?
        InformeDeRecaudacionView.where('fecha_notificacion BETWEEN ? AND ?',
          params[:biannual], (params[:biannual].to_date + 5.months).at_end_of_month.strftime('%d/%m/%Y'))
      elsif !params[:year].blank?
        InformeDeRecaudacionView.where('fecha_notificacion BETWEEN ? AND ?',
          params[:year], params[:year].to_date.at_end_of_year.strftime('%d/%m/%Y'))
      else
        InformeDeRecaudacionView.all
      end

    total = t_facturas.where("razon_social ILIKE ?", "%#{params[:razon_social]}%").sum(:total_factura).truncate(2)
    results = {
      procesado: true,
      total: total
    }

    render json: results
  end

  def informe_ingresos_diarios
    @usar_dataTables = true
    @do_not_use_plain_select2 = true
    @no_cache = true

    @attributes_to_display = [
      :id, :fecha_notificacion, :fecha_vencimiento, :fecha_pago, :identificacion,
      :razon_social, :tipo_cliente, :detalle, :monto
    ]

    respond_to do |format|
      format.html
      format.json { render json: InformeDeIngresosDiariosDatatable.new(
        params.merge({
          attributes_to_display: @attributes_to_display
        }),
        view_context: view_context)
      }
    end
  end

  def informe_ingresos_presupuesto
    @usar_dataTables = true
    @do_not_use_plain_select2 = true
    @no_cache = true

    @attributes_to_display = [
      :codigo, :anio_pago, :pago_enero, :pago_febrero, :pago_marzo,
      :pago_abril, :pago_mayo, :pago_junio, :pago_julio, :pago_agosto,
      :pago_septiembre, :pago_octubre, :pago_noviembre, :pago_diciembre, :total
    ]

    respond_to do |format|
      format.html
      format.json { render json: InformeDeIngresosPresupuestoDatatable.new(
        params.merge({
          attributes_to_display: @attributes_to_display
        }),
        view_context: view_context)
      }
    end
  end

  def informe_cuentas_x_cobrar
    @usar_dataTables = true
    @useDataTableFooter = true
    @do_not_use_plain_select2 = true
    @no_cache = true

    @attributes_to_display = [
      :descripcion, :cantidad_clientes, :cantidad_facturas, :dias_0_30,
      :dias_31_60, :dias_61_90, :dias_91_120, :dias_mas_de_120, :total
    ]

    respond_to do |format|
      format.html
      format.json { render json: InformeDeCuentasXCobrarDatatable.new(
        params.merge({
          attributes_to_display: @attributes_to_display
        }),
        view_context: view_context)
      }
    end
  end

  def total_cuentas_x_cobrar
    dataTable = InformeDeCuentasXCobrarDatatable.new(
      params.merge({
        attributes_to_display: @attributes_to_display
      }),
      view_context: view_context
    )
    total = dataTable.get_raw_records.sum(:total).truncate(2)
    results = {
      procesado: true,
      total: total
    }
    render json: results
  end

  def informe_presupuestario
    @usar_dataTables = true
    # @useDataTableFooter = true
    @do_not_use_plain_select2 = true
    @no_cache = true

    @attributes_to_display = [:codigo, :descripcion, :pago_pendiente]

    respond_to do |format|
      format.html
      format.json { render json: InformePresupuestarioDatatable.new(
        params.merge({
          attributes_to_display: @attributes_to_display
        }),
        view_context: view_context)
      }
    end
  end

  def informe_por_tipos_de_ingreso
    @usar_dataTables = true
    # @useDataTableFooter = true
    @do_not_use_plain_select2 = true
    @no_cache = true

    @attributes_to_display = [
      :t_factura_id, :t_recibo_id, :fecha_pago, :codigo,
      :cliente, :metodo_pago, :estado, :importe
    ]

    respond_to do |format|
      format.html
      format.json { render json: InformePorTiposDeIngresoDatatable.new(
        params.merge({
          attributes_to_display: @attributes_to_display
        }),
        view_context: view_context)
      }
    end
  end

  def estado_de_cuenta
    @usar_dataTables = true
    @useDataTableFooter = true
    @do_not_use_plain_select2 = true
    @no_cache = true

    @attributes_to_display = [
      :fecha_notificacion, :fecha_vencimiento, :t_factura_id, :t_recibo_id,
      :t_presupuesto, :servicio_nombre, :servicio_descripcion, :debito,
      :credito, :saldo
    ]

    respond_to do |format|
      format.html
      format.json { render json: EstadoDeCuentaDatatable.new(
        params.merge({
          attributes_to_display: @attributes_to_display
        }),
        view_context: view_context)
      }
    end
  end

  def filtrar_estado_de_cuenta
    dataTable = EstadoDeCuentaDatatable.new(
      params.merge({
        attributes_to_display: @attributes_to_display
      }),
      view_context: view_context
    )
    debito = dataTable.get_raw_records.sum(:pago_recibido).truncate(2)
    credito = dataTable.get_raw_records.sum(:monto_acreditado).truncate(2)
    saldo = dataTable.get_raw_records.sum(:pago_pendiente).truncate(2)
    results = {
      procesado: true,
      debito: debito,
      credito: credito,
      saldo: saldo
    }
    render json: results
  end

  def mostrar_datos_del_cliente
    t_clientes = TCliente
      .select(:id, :codigo, "
        res.resolucion,
        COALESCE(e.rif, o.identificacion, p.cedula) ide,
        COALESCE(e.razon_social, o.razon_social, CONCAT(p.nombre, ' ', p.apellido)) rs,
        COALESCE(e.direccion_empresa, p.direccion) direccion,
        COALESCE(e.telefono, p.telefono, o.telefono) telefono,
        COALESCE(e.email, p.email, o.email) email")
      .joins("
        LEFT OUTER JOIN t_empresas e ON e.id = t_clientes.persona_id AND t_clientes.persona_type = 'TEmpresa'
        LEFT OUTER JOIN t_personas p ON p.id = t_clientes.persona_id AND t_clientes.persona_type = 'TPersona'
        LEFT OUTER JOIN t_otros    o ON o.id = t_clientes.persona_id AND t_clientes.persona_type = 'TOtro'
        LEFT OUTER JOIN t_resolucions res ON res.t_cliente_id = t_clientes.id")
    if params[:attribute] == 'select-cliente'
      @t_cliente = t_clientes.find_by(id: params[:t_cliente_id])
    elsif params[:attribute] == 'select-codigo'
      @t_cliente = t_clientes.find_by(codigo: params[:codigo])
    elsif params[:attribute] == 'select-cedula'
      @t_cliente = t_clientes
        .where("COALESCE(e.rif, o.identificacion, p.cedula) = ?", params[:identificacion]).take
    end
  end

  private

    def t_factura_params
      params.require(:t_factura).permit(
        :fecha_notificacion, :fecha_vencimiento, :recargo_desc,
        :t_resolucion_id, :t_periodo_id, :total_factura,
        t_factura_detalles_attributes: [
          :id, :cantidad, :cuenta_desc, :_destroy,
          :precio_unitario, :t_tarifa_servicio_id
        ],
        t_recargo_facturas_attributes: [
          :id, :cantidad, :_destroy,
          :precio_unitario, :t_recargo_id
        ]
      )
    end

    def set_t_factura
      @t_factura = TFactura.find(params[:id])
    end

    def set_dynamic_attributes
      t_resolucion = @t_factura.t_resolucion
      t_cliente    = t_resolucion.try(:t_cliente) || @t_factura.t_cliente
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
            resolucion: t_resolucion.try(:resolucion),
            resolucion_id: t_resolucion.try(:id),
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

    def authorize_user_to_read_reports
      authorize! :read_reports, TFactura
    end
end
