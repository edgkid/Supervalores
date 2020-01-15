class TRecibosController < ApplicationController
  before_action :set_t_factura, except: [:index, :listado_recibos, :comparativa_ingresos_no_datatables, :pago_recibido_total]
  before_action :set_preview_data, only: :new
  before_action :set_t_recibo, only: [:show, :destroy, :generar_pdf]
  before_action :set_necessary_objects, only: [:new, :create, :show]

  load_and_authorize_resource except: [:pago_recibido_total, :generar_pdf,
    :generar_reporte_pdf, :listado_recibos, :comparativa_ingresos_no_datatables]
  before_action :authorize_user_to_read_reports, only: [:listado_recibos,
    :comparativa_ingresos_no_datatables]


  def new
    @last_t_recibo = TRecibo.find(params[:recibo_id]) if params[:recibo_id]
    @t_recibo = TRecibo.new
  end

  def create
    @t_recibo = TRecibo.new(t_recibo_params)
    @t_recibo.set_surcharge_and_services_total(@t_recibo.pago_recibido || 0, @t_factura, @t_factura.t_recibos.empty?)
    @t_recibo.calculate_default_attributes(@t_factura, @t_cliente, current_user)
    penultimo_recibo = @t_factura.t_recibos.find_by(ultimo_recibo: true)
    penultimo_recibo.ultimo_recibo = false if penultimo_recibo
    if @t_recibo.save
      penultimo_recibo.update_attribute(:ultimo_recibo, false) if penultimo_recibo
      if @t_recibo.monto_acreditado > 0
        t_nota_credito = TNotaCredito.new
        t_nota_credito.t_cliente_id = @t_recibo.t_cliente_id
        t_nota_credito.t_recibo_id = @t_recibo.id
        t_nota_credito.monto = @t_recibo.monto_acreditado
        t_nota_credito.status = "Sin Usar"
        t_nota_credito.monto_original =  @t_recibo.monto_acreditado
        t_nota_credito.save!
      end
      @t_factura.update_attribute(:pendiente_fact, @t_factura.pendiente_fact - @t_recibo.pago_recibido)
      if @t_recibo.pago_pendiente <= 0
        @t_factura.update_attribute(:t_estatus_id, TEstatus.find_by(descripcion: 'Cancelada').id)
      else
        @t_factura.update_attribute(:t_estatus_id, TEstatus.find_by(descripcion: 'Pago Pendiente').id)
      end
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
      :id, :fecha_pago, :forma_pago, :razon_social,
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

  def listado_recibos
    @available_years = TRecibo.years_options

    if params[:filter] == "true"
      @recibos = TRecibo.all

      unless params[:day].blank?
        @recibos = @recibos.where(fecha_pago: Date.parse(params[:day])).distinct
      end

      unless (params[:from].blank? || params[:to].blank?)
        @recibos = @recibos.where("fecha_pago BETWEEN ? AND ?", params[:from], params[:to]).distinct
      end

      unless params[:month].blank?
        @recibos = @recibos.where("extract(year from Date(fecha_pago)) = #{params[:month].partition("/").last}").where("extract(month from Date(fecha_pago)) = #{params[:month].partition("/").first}").distinct
      end

      unless params[:year].blank?
        @recibos = @recibos.where("extract(year from Date(fecha_pago)) = #{params[:year]}").distinct
      end

      unless params[:search_client].blank?
        personas_naturales_ids = TPersona.joins(:t_cliente).where("lower(nombre) like ? or lower(apellido) like ?", "%#{params[:search_client].downcase}%", "%#{params[:search_client].downcase}%").pluck(:"t_clientes.id")
        personas_juridicas_ids = TEmpresa.joins(:t_cliente).where("lower(razon_social) like ?", "%#{params[:search_client].downcase}%").pluck(:"t_clientes.id")
        @recibos = @recibos.where(t_cliente_id: personas_naturales_ids + personas_juridicas_ids).distinct

      end

      unless params[:search_service].blank?
        @recibos = @recibos.joins(t_factura: [t_factura_detalles: :t_tarifa_servicio]).where("lower(t_tarifa_servicios.descripcion) like ?", "%#{params[:search_service].downcase}%").distinct
      end

      recibos_ids = []
      @total_pagos_recibidos = 0
      @recibos.each do |recibo|
        recibos_ids << recibo.id
        @total_pagos_recibidos += recibo.pago_recibido
      end

      @recibos = TRecibo.where(id: recibos_ids).includes(t_factura: [t_factura_detalles: :t_tarifa_servicio]).includes(t_cliente: :persona)

      per_page = @recibos.count
      @recibos.paginate(page: params[:page], per_page: per_page) unless @recibos.nil?

    else
      @recibos = nil  
    end
    
    

    respond_to do |format|
      format.html

      # format.json { render json: ComparativaIngresosDatatable.new(
      #   params.merge({
      #     attributes_to_display: @attributes_to_display
      #   }),
      #   view_context: view_context)
      # }
    end
  end

  def comparativa_ingresos_no_datatables
    montos = []
    
    starting_time = Time.now

    query_years = []
    query_years << Date.today.strftime("%Y").to_i if (params[:from].blank? && params[:to].blank?)
    starting_year = params[:from].to_i
    finishing_year = params[:to].to_i

    while starting_year <= finishing_year
      query_years << starting_year
      starting_year += 1
    end
    
    @resoluciones = TResolucion.joins(t_facturas: [{t_factura_detalles: :t_tarifa_servicio}, :t_recibos]).includes(t_facturas: [{t_factura_detalles: :t_tarifa_servicio}, :t_recibos]).where("extract(year from Date(t_recibos.fecha_pago)) in (#{query_years.join(',')})")

    starting_time = Time.now
    @servicio_mes_monto = []
    @tarifas_servicios = TTarifaServicio.where.not(estatus: 0)
    @tarifas_servicios.each do |tarifa_servicio|
      
      @servicio_mes_monto.push(
          "SERVICIO" => "#{tarifa_servicio.descripcion}",
          "ENERO" => 0,
          "FEBRERO" => 0,
          "MARZO" => 0,
          "ABRIL" => 0,
          "MAYO" => 0,
          "JUNIO" => 0,
          "JULIO" => 0,
          "AGOSTO" => 0,
          "SEPTIEMBRE" => 0,
          "OCTUBRE" => 0,
          "NOVIEMBRE" => 0,
          "DICIEMBRE" => 0,
          "TOTAL" => 0)
    end

    @tarifas_servicios.each do |tarifa_servicio|
      @recargos = @servicio_mes_monto.select{|e| e["SERVICIO"].downcase.include?("recargo") }.first
      recibos = TRecibo.where("extract(year from Date(t_recibos.fecha_pago)) in (#{query_years.join(',')})").joins(:t_factura => [:t_factura_detalles => :t_tarifa_servicio]).where(:t_factura_detalles => {:t_tarifa_servicio_id => tarifa_servicio.id}).includes(t_factura: [:t_factura_detalles, :t_recargo_facturas])
      mes = 1
      while mes <= 12

        recibos.where("extract(month from Date(t_recibos.fecha_pago)) = #{mes}").each do |recibo|

          monto_de_servicio = recibo.pago_recibido
          recargos_a_cancelar = 0

          if recibo.ultimo_recibo

            recargos_a_cancelar = recibo.recargo_x_pagar.nil? ? 0 : recibo.recargo_x_pagar

            if recibo.pago_recibido >= recargos_a_cancelar
              monto_de_servicio = monto_de_servicio - recargos_a_cancelar
            elsif recibo.pago_recibido < recargos_a_cancelar
              monto_de_servicio = 0
              recargos_a_cancelar = recibo.pago_recibido
            end
          end

          @selected_mes_monto = @servicio_mes_monto.select{|e| e["SERVICIO"] == tarifa_servicio.descripcion}.first

          case mes
            when 1
              @selected_mes_monto["ENERO"] += monto_de_servicio
              @recargos["ENERO"] += recargos_a_cancelar 
            when 2
              @selected_mes_monto["FEBRERO"] += monto_de_servicio
              @recargos["FEBRERO"] += recargos_a_cancelar 
            when 3
              @selected_mes_monto["MARZO"] += monto_de_servicio
              @recargos["MARZO"] += recargos_a_cancelar 
            when 4
              @selected_mes_monto["ABRIL"] += monto_de_servicio
              @recargos["ABRIL"] += recargos_a_cancelar 
            when 5
              @selected_mes_monto["MAYO"] += monto_de_servicio
              @recargos["MAYO"] += recargos_a_cancelar 
            when 6
              @selected_mes_monto["JUNIO"] += monto_de_servicio
              @recargos["JUNIO"] += recargos_a_cancelar 
            when 7
              @selected_mes_monto["JULIO"] += monto_de_servicio
              @recargos["JULIO"] += recargos_a_cancelar 
            when 8
              @selected_mes_monto["AGOSTO"] += monto_de_servicio
              @recargos["AGOSTO"] += recargos_a_cancelar 
            when 9
              @selected_mes_monto["SEPTIEMBRE"] += monto_de_servicio
              @recargos["SEPTIEMBRE"] += recargos_a_cancelar 
            when 10
              @selected_mes_monto["OCTUBRE"] += monto_de_servicio
              @recargos["OCTUBRE"] += recargos_a_cancelar 
            when 11
              @selected_mes_monto["NOVIEMBRE"] += monto_de_servicio
              @recargos["NOVIEMBRE"] += recargos_a_cancelar 
            when 12
              @selected_mes_monto["DICIEMBRE"] += monto_de_servicio
              @recargos["DICIEMBRE"] += recargos_a_cancelar 
          end

          @selected_mes_monto["TOTAL"] += monto_de_servicio
          @recargos["TOTAL"] += recargos_a_cancelar 

        end
        mes += 1
      end

    end 

    @totales = [
      "ENERO" => 0,
      "FEBRERO" => 0,
      "MARZO" => 0,
      "ABRIL" => 0,
      "MAYO" => 0,
      "JUNIO" => 0,
      "JULIO" => 0,
      "AGOSTO" => 0,
      "SEPTIEMBRE" => 0,
      "OCTUBRE" => 0,
      "NOVIEMBRE" => 0,
      "DICIEMBRE" => 0].first

    @servicio_mes_monto.each do |servicio|
      @totales["ENERO"] += servicio["ENERO"]
      @totales["FEBRERO"] += servicio["FEBRERO"]
      @totales["MARZO"] += servicio["MARZO"]
      @totales["ABRIL"] += servicio["ABRIL"]
      @totales["MAYO"] += servicio["MAYO"]
      @totales["JUNIO"] += servicio["JUNIO"]
      @totales["JULIO"] += servicio["JULIO"]
      @totales["AGOSTO"] += servicio["AGOSTO"]
      @totales["SEPTIEMBRE"] += servicio["SEPTIEMBRE"]
      @totales["OCTUBRE"] += servicio["OCTUBRE"]
      @totales["NOVIEMBRE"] += servicio["NOVIEMBRE"]
      @totales["DICIEMBRE"] += servicio["DICIEMBRE"]
    end

    ending_time = Time.now

    @elapsed_time = ending_time - starting_time

    ending_time = Time.now

    @elapsed_time = ending_time - starting_time 
    
    @monto_final = 0
    @servicio_mes_monto.each{|e| @monto_final += e["TOTAL"]}
    @usar_dataTables = true
    @useDataTableFooter = true
    @do_not_use_plain_select2 = true
    @no_cache = true

    @attributes_to_display = [
      :id, :fecha_pago, :detalle_factura, :nombre_servicio,
      :descripcion_servicio, :identificacion, :razon_social, :pago_recibido
    ]

    respond_to do |format|
      format.html
      format.json { render json: ComparativaIngresosDatatable.new(
        params.merge({
          attributes_to_display: @attributes_to_display
        }),
        view_context: view_context)
      }
    end
  end

  def pago_recibido_total
    dataTable = ComparativaIngresosDatatable.new(
      params.merge({
        attributes_to_display: @attributes_to_display
      }),
      view_context: view_context
    )
    total = dataTable.get_raw_records.sum(:pago_recibido).truncate(2)
    results = {
      procesado: true,
      total: total
    }
    render json: results
  end

  def generar_pdf
    # debugger
    if params[:notas_credito] == "true"
      # debugger
      pdf = TNotasCreditoPdf.new(@t_factura, @t_recibo, current_user.id)
      send_data(
        pdf.render,
        filename: "recibo_nro_#{@t_recibo.id}.pdf",
        type: "application/pdf",
        disposition: "inline"
      ) and return
    else
      pdf = TReciboPdf.new(@t_factura, @t_recibo, current_user.id)
      send_data(
        pdf.render,
        filename: "recibo_nro_#{@t_recibo.id}.pdf",
        type: "application/pdf",
        disposition: "inline"
      ) and return
    end
    
  end

  def generar_reporte_pdf
    cliente_ruc_o_cedula = params[:selected_client].split(" - ").first.strip unless params[:selected_client].blank?
    tarifa_servicio_codigo = params[:selected_service].split(" - ").second.strip unless params[:selected_service].blank?
    pdf = TReporteComparativaIngresosXTarifaClientePdf.new(cliente_ruc_o_cedula, tarifa_servicio_codigo)
    send_data(
      pdf.render,
      filename: "test_reporte.pdf",
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

    def authorize_user_to_read_reports
      authorize! :read_reports, TRecibo
    end

    def set_preview_data
      @t_resolucion = @t_factura.t_resolucion
      # @t_tarifa  = @t_resolucion.t_tipo_cliente.t_tarifa
      @t_periodo = @t_factura.t_periodo
      @t_estatus = @t_factura.t_estatus
      @t_cliente = @t_resolucion.try(:t_cliente) || @t_factura.try(:t_cliente)

      @t_empresa = @t_cliente.persona.try(:rif)            ? @t_cliente.persona : nil
      @t_persona = @t_cliente.persona.try(:cedula)         ? @t_cliente.persona : nil
      @t_otro    = @t_cliente.persona.try(:identificacion) ? @t_cliente.persona : nil
    end

    def set_necessary_objects
      @t_recibos = @t_factura.t_recibos
      @t_nota_creditos = @t_factura.t_nota_creditos.any? ? @t_factura.t_nota_creditos : @t_factura.t_resolucion.try(:t_cliente).try(:t_nota_creditos) || @t_factura.t_cliente.try(:t_nota_creditos)
      # @t_nota_creditos = @t_factura.t_nota_creditos
      # @pending_payment = @t_factura.pendiente_total.truncate(2)
      if @t_factura.t_recibos.any?
        @pending_payment = @t_factura.t_recibos.find_by(ultimo_recibo: true).pago_pendiente.truncate(2)
      else
        @pending_payment = @t_factura.calculate_pending_payment.truncate(2)
      end

      @t_resolucion = @t_factura.t_resolucion
      # @t_tarifa  = @t_resolucion.t_tipo_cliente.t_tarifa
      @t_estatus = @t_factura.t_estatus
      @t_cliente = @t_resolucion.try(:t_cliente) || @t_factura.try(:t_cliente)
      @t_persona = @t_cliente.persona
      if @t_persona.class.to_s == 'TEmpresa'
        @t_empresa = @t_persona
        @t_persona = nil
      else
        @t_empresa = @t_persona.t_empresa
      end
    end
end
