class TClientesController < ApplicationController
  # include TClientesHelper

  respond_to :js, only: [:find]
  respond_to :json, only: [:all_clients, :find_by_codigo, :find_by_resolucion,
    :find_by_cedula, :find_by_razon_social]
  before_action :seleccionar_cliente, only: [:show, :edit, :update, :destroy, :nueva_resolucion, :nueva_empresa]
  before_action :usar_dataTables_en, only: [:index, :show, :edit, :estado_cuenta, :nueva_resolucion]
  before_action :dataTables_resolucion, only: [:show, :edit, :nueva_resolucion]
  before_action :seleccionar_resolucion, only: [:mostrar_resolucion]
  before_action :authorize_user_to_read_reports, only: [:tramites]
  # before_action :clients_with_resolutions, only: :find_by_codigo
  # before_action :companies_with_clients_with_resolutions, only: :find_by_cedula

  def all_clients
    search = parametros_de_busqueda[:search]
    respond_with TCliente.all_clients.where("
      codigo ILIKE ?
      OR COALESCE(e.rif, o.identificacion, p.cedula) ILIKE ?
      OR COALESCE(e.razon_social, o.razon_social, CONCAT(p.nombre, ' ', p.apellido)) ILIKE ?
      ", "%#{search}%", "%#{search}%", "%#{search}%"
    )
  end

  def index
    @attributes_to_display = [
      :codigo,
      :identificacion,
      :razon_social,
      :telefono,
      :email,
      :es_prospecto,
      :estatus,
      :tipo_persona,
      :created_at,
    ]
    respond_to do |format|
      format.html
      format.json { render json: TClienteDatatable.new(
        params.merge({
          attributes_to_display: @attributes_to_display
        }),
        view_context: view_context)
      }
    end
  end

  def estado_cuenta
    @do_not_use_plain_select2 = true   
    @useDataTableFooter = true

    @attributes_to_display = [
      :numero, :fecha_notificacion, :fecha_vencimiento, :recargo,
      :total_factura, :pendiente_fact, :tipo, :numero_recibo,
      :debito, :credito, :saldo, :usuario,
    ]

    @attributes_to_display2 = [
      :dias_0_30, :dias_31_60, :dias_61_90, :dias_91_120,
      :dias_mas_de_120, :total
    ]

    respond_to do |format|
      format.html
      if params[:cuentas_x_cobrar] == 'true'
        format.json { render json: CuentasXCobrarXClienteDatatable.new(
          params.merge({
            attributes_to_display: @attributes_to_display,
            t_resolucion_id: params[:t_resolucion_id]
          }),
          view_context: view_context)
        }
      else
        format.json { render json: EstadoCuentaDatatable.new(
          params.merge({
            attributes_to_display: @attributes_to_display,
            t_resolucion_id: params[:t_resolucion_id]
          }),
          view_context: view_context)
        }
      end
    end
  end

  def estado_cuenta_calculo_de_totales
    t_resolucion_id = params[:t_resolucion_id]
    if t_resolucion_id != ""
      resolucion = TResolucion.find(t_resolucion_id)
      sum_total = TFactura
        .joins(:t_estatus)
        .left_joins({t_recibos: :user}, {t_resolucion: :t_cliente})
        .where("
          t_resolucions.id = ? AND
          (t_estatuses.descripcion = ? OR
          t_estatuses.descripcion = ?)",
          params[:t_resolucion_id], 'Facturada', 'Pago Pendiente')
        .sum("t_facturas.total_factura")

      sum_pago_recibido = TFactura
        .joins(:t_estatus)
        .left_joins({t_recibos: :user}, {t_resolucion: :t_cliente})
        .where("
          t_resolucions.id = ? AND
          (t_estatuses.descripcion = ? OR
          t_estatuses.descripcion = ?)",
          params[:t_resolucion_id], 'Facturada', 'Pago Pendiente')
        .sum("COALESCE(t_recibos.pago_recibido, 0)")

      sum_monto_acreditado = TFactura
        .joins(:t_estatus)
        .left_joins({t_recibos: :user}, {t_resolucion: :t_cliente})
        .where("
          t_resolucions.id = ? AND
          (t_estatuses.descripcion = ? OR
          t_estatuses.descripcion = ?)",
          params[:t_resolucion_id], 'Facturada', 'Pago Pendiente')
        .sum("COALESCE(t_recibos.monto_acreditado, 0)")
    
      deuda = sum_total - sum_pago_recibido
      render json: {
        procesado: true,
        total: view_context.number_to_balboa(sum_total, false),
        mostrar_paz_y_salvo: sum_total > 0 && deuda == 0,
        por_pagar: view_context.number_to_balboa(deuda, false),
        total_pago_recibido: view_context.number_to_balboa(sum_pago_recibido, false),
        total_monto_acreditado: view_context.number_to_balboa(sum_monto_acreditado, false),
        cliente_id: resolucion.t_cliente.id,
        cliente_codigo: resolucion.t_cliente.codigo
      }
    else
      render json: {
        procesado: false
      }
    end
  end

  def show
  end

  def new
    @do_not_use_plain_select2 = true    
    @registro = TCliente.new
    @registro.t_estatus_id = 2
    @registro.es_prospecto = true
  end

  def edit
    @do_not_use_plain_select2 = true
  end

  def create    
    @registro = TCliente.new(parametros_cliente)
    @nueva_empresa = nil
    if es_empresa
      if params[:t_empresa][:id]
        @registro.persona = TEmpresa.find(params[:t_empresa][:id])
      else
        @registro.persona = TEmpresa.new(parametros_cliente_tipo_empresa)
      end      
    elsif es_persona
      if params[:t_persona][:id]
        @registro.persona = TPersona.find(params[:t_persona][:id])
      else
        @registro.persona = TPersona.new(parametros_cliente_tipo_persona)
      end
      if params[:t_persona][:crear_empresa] == "1"
        @nueva_empresa = TEmpresa.new(parametros_nueva_empresa)
        if @nueva_empresa.save
          @registro.persona.t_empresa = @nueva_empresa
          @nueva_empresa = nil
        end
      end
    else
      if params[:t_otro][:id]
        @registro.persona = TOtro.find(params[:t_otro][:id])
      else
        @registro.persona = TOtro.new(parametros_cliente_tipo_otro)
      end
    end
    @registro.persona.t_cliente = @registro
    @registro.es_prospecto = es_prospecto
    @resolucion = nil
    @contacto = nil
    if !@registro.es_prospecto
      @resolucion = TResolucion.new(parametros_resolucion)
      @resolucion.usar_cliente = usar_cliente
      @resolucion.t_cliente = @registro
      @registro.prospecto_at = Time.now
      if !@resolucion.usar_cliente
        @contacto = TContacto.new(parametros_contacto)
        @contacto.t_resolucion = @resolucion
      end
    else
      @registro.prospecto_at = nil
    end
    
    respond_to do |format|
      if @nueva_empresa != nil && @nueva_empresa.errors.any?
        @notice = @nueva_empresa.errors
        format.html { render :new }
        format.json { render json: @nueva_empresa.errors, status: :unprocessable_entity }
      elsif !@registro.valid?
        @notice = @registro.errors
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      elsif !@registro.persona.valid?
        @nueva_empresa = nil
        @notice = @registro.persona.errors
        format.html { render :new }
        format.json { render json: @registro.persona.errors, status: :unprocessable_entity }
      elsif !@registro.es_prospecto && @resolucion != nil && !@resolucion.valid?
        @notice = @resolucion.errors
        format.html { render :new }
        format.json { render json: @resolucion.errors, status: :unprocessable_entity }
      elsif !@registro.es_prospecto && @resolucion != nil && !@resolucion.usar_cliente && !@contacto.valid?
        @notice = @contacto.errors
        format.html { render :new }
        format.json { render json: @contacto.errors, status: :unprocessable_entity }
      else
        @registro.persona.save
        @registro.save        
        
        if @resolucion != nil
          @resolucion.save
          if @contacto != nil
            @contacto.t_resolucion = @resolucion
            @contacto.save
          end
          format.html { redirect_to t_cliente_path(@registro), notice: 'Cliente y resolución creado correctamente.' }
          format.json { render :show, status: :created, location: @registro }
        else
          format.html { redirect_to t_cliente_path(@registro), notice: 'Cliente creado correctamente.' }
          format.json { render :show, status: :created, location: @registro }
        end
      end
    end
  end

  def update
    crear = false
    actualizar = false
    parametros = {}
    @nueva_empresa = nil

    if es_empresa
      if @registro.persona != nil && @registro.persona.is_a?(TEmpresa)
        actualizar = true
        parametros = parametros_cliente_tipo_empresa
      else
        crear = true
        @registro.persona = TEmpresa.new(parametros_cliente_tipo_empresa)
      end
    elsif es_persona
      if @registro.persona != nil && @registro.persona.is_a?(TPersona)
        actualizar = true
        parametros = parametros_cliente_tipo_persona
      else
        crear = true
        @registro.persona.destroy
        @registro.persona = TPersona.new(parametros_cliente_tipo_persona)
      end
      if params[:t_persona][:crear_empresa] == "1"
        @nueva_empresa = TEmpresa.new(parametros_nueva_empresa)
        if @nueva_empresa.save
          if actualizar
            parametros[:t_empresa_id] = @nueva_empresa.id
          else
            @registro.persona.t_empresa = @nueva_empresa
          end
          @nueva_empresa = nil
        end          
      end
    else
      if @registro.persona != nil && @registro.persona.is_a?(TOtro)
        actualizar = true
        parametros = parametros_cliente_tipo_otro
      else
        crear = true
        @registro.persona.destroy
        @registro.persona = TOtro.new(parametros_cliente_tipo_otro)
      end
    end
    
    @registro.assign_attributes(parametros_cliente)
    if (actualizar)
      @registro.persona.assign_attributes(parametros)
    end      
    @registro.persona.t_cliente = @registro
    @registro.es_prospecto = es_prospecto
    @resolucion = nil
    @contacto = nil
    
    if (!@registro.es_prospecto && @registro.prospecto_at == nil)
      @resolucion = TResolucion.new(parametros_resolucion)
      @resolucion.usar_cliente = usar_cliente
      @resolucion.t_cliente = @registro
      @registro.prospecto_at = Time.now
      if !@resolucion.usar_cliente
        @contacto = TContacto.new(parametros_contacto)
        @contacto.t_resolucion = @resolucion
      end
    end

    respond_to do |format|
      if @nueva_empresa != nil && @nueva_empresa.errors.any?
        @notice = @nueva_empresa.errors
        format.html { render :edit }
        format.json { render json: @nueva_empresa.errors, status: :unprocessable_entity }
      elsif !@registro.valid?
        @notice = @registro.errors
        format.html { render :edit }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      elsif !@registro.persona.valid?
        @nueva_empresa = nil
        @notice = @registro.persona.errors
        format.html { render :edit }
        format.json { render json: @registro.persona.errors, status: :unprocessable_entity }
      elsif !@registro.es_prospecto && @resolucion != nil && !@resolucion.valid?
        @notice = @resolucion.errors
        format.html { render :edit }
        format.json { render json: @resolucion.errors, status: :unprocessable_entity }
      elsif !@registro.es_prospecto && @resolucion != nil && !@resolucion.usar_cliente && !@contacto.valid?
        @notice = @contacto.errors
        format.html { render :edit }
        format.json { render json: @contacto.errors, status: :unprocessable_entity }
      else
        @registro.persona.save
        @registro.save

        if @resolucion != nil
          @resolucion.save
          if @contacto != nil
            @contacto.t_resolucion = @resolucion
            @contacto.save
          end
          format.html { redirect_to t_cliente_path(@registro), notice: 'Cliente y resolución actualizado correctamente.' }
          format.json { render :show, status: :created, location: @registro }
        else
          format.html { redirect_to t_cliente_path(@registro), notice: 'Cliente actualizado correctamente.' }
          format.json { render :show, status: :created, location: @registro }
        end
      end
    end
  end

  def nueva_resolucion
    @resolucion = TResolucion.new(parametros_resolucion)
    @resolucion.usar_cliente = usar_cliente    
          
    @contacto = nil          
    if !usar_cliente
      @contacto = TContacto.new(parametros_contacto)
      @contacto.t_resolucion = @resolucion
      @contacto.valid?
    end
    @resolucion.valid?

    respond_to do |format|
      if @contacto != nil && @contacto.errors.any?
        @notice = @contacto.errors
        format.html { render :edit }
        format.json { render json: @contacto.errors, status: :unprocessable_entity }
      elsif @resolucion.errors.any?
        @notice = @resolucion.errors
        format.html { render :edit }
        format.json { render json: @resolucion.errors, status: :unprocessable_entity }
      else
        @resolucion.save
        format.html { render :edit, notice: 'Resolución asociada correctamente.' }
        format.json { render :show, status: :ok, location: @resolucion }
      end
    end
  end

  def mostrar_resolucion
  end
  
  def destroy
    @registro.t_estatus = TEstatus.find(1)
    respond_to do |format|
      if @registro.save
        format.html { redirect_to t_clientes_url, notice: 'Cliente inhabilitado correctamente.' }
        format.json { head :no_content }
      else
        @notice = @registro.errors
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  def find_by_codigo
    search = parametros_de_busqueda[:search]
    respond_with ViewClient.where('codigo ILIKE ?', "%#{search}%")
      .where(estatus: 'Disponible').first(50)
  end

  def find_by_cedula
    search = parametros_de_busqueda[:search]

    personas = ViewClient.where('identificacion ILIKE ?', "%#{search}%")
      .where(estatus: 'Disponible').first(50)
    
    respond_with personas
    # respond_with TCliente.where('razon_social LIKE ?', "%#{search}%").first(10)
  end

  def find_by_resolucion
    search = parametros_de_busqueda[:search]
    respond_with TResolucion.where('resolucion ILIKE ?', "%#{search}%")
      .where(estatus: 'Disponible').first(50)
  end

  def find_by_razon_social
    search = parametros_de_busqueda[:search]

    clientes = ViewClient.where("razon_social ILIKE ?", "%#{search}%")
      .where(estatus: 'Disponible').first(50)
    respond_with clientes
  end

  def find
    @attribute = parametros_de_busqueda[:attribute]
    search = parametros_de_busqueda[:search]

    case @attribute
    when 'select-codigo'
      @t_cliente = TCliente.where('codigo = ?', search).take

      persona = @t_cliente.persona
      case persona.class.to_s
      when 'TPersona'
        @t_persona = persona
      when 'TEmpresa'
        @t_empresa = persona
      end
    when 'select-resolucion'
      @t_resolucion = TResolucion.find(search)
      @t_tarifa = @t_resolucion.t_tipo_cliente.t_tarifa
      @t_cliente = @t_resolucion.t_cliente
      @t_persona = @t_cliente.persona
    when 'select-cedula'
      view = ViewClient.where('identificacion = ?', search).take
      @t_cliente = TCliente.find(view.id)
      persona = @t_cliente.persona
      case persona.class.to_s
      when 'TPersona'
        @t_persona = persona
      when 'TEmpresa'
        @t_empresa = persona
        @without_client = true unless @t_cliente
      end
    when 'select-cliente'
      #view = ViewClient.where('razon_social = ?', search).take
      #debugger
      #@t_cliente = TCliente.find(view.id)
      @t_cliente = TCliente.find(search)
      persona = @t_cliente.persona
      case persona.class.to_s
      when 'TPersona'
        @t_persona = persona
      when 'TEmpresa'
        @t_empresa = persona
        @without_client = true unless @t_cliente
      end
    end if search != ''

    if @t_persona.class.to_s == 'TEmpresa'
      @t_empresa = @t_persona
      @t_persona = nil
    end
  end

  def tramites
    @usar_dataTables = true
    @do_not_use_plain_select2 = true
    @no_cache = true

    @attributes_to_display = [
      :created_at, :codigo, :ced_pas_ruc, :razon_social,# :telefono, :email,
      :es_prospecto, :t_estatus
    ]

    respond_to do |format|
      format.html
      format.json { render json: TTramitesDatatable.new(
        params.merge({
          attributes_to_display: @attributes_to_display
        }),
        view_context: view_context)
      }
    end
  end

  def total
    # debugger
    dataTable =  TTramitesDatatable.new(
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

  def generar_pdf
    
    current_user_full_name = "#{current_user.nombre} #{current_user.apellido}" 
    @t_resolucion = TResolucion.find(params[:resolution_id])
    @t_cliente = @t_resolucion.t_cliente
    pdf = TEstadoCuentaPdf.new(@t_cliente, @t_resolucion, current_user_full_name)
    send_data(
      pdf.render,
      filename: "estado_cuenta.pdf",
      type: "application/pdf",
      disposition: "inline"
    ) and return
  end

  private
    def seleccionar_cliente
      @registro = TCliente.find(params[:id])
      @registro.es_prospecto = @registro.prospecto_at == nil
    end

    def seleccionar_resolucion
      @mostrar_resolucion = TResolucion.find(params[:resolucion])
      @mostrar_resolucion.usar_cliente = usar_cliente
    end

    def parametros_cliente
      params.require(:t_cliente).permit(:codigo, :t_estatus_id, :cuenta_venta, :t_tipo_persona_id, :razon_social, :telefono, :email, :es_prospecto)
    end
    
    def parametros_cliente_tipo_empresa
      params.require(:t_empresa).permit(:rif, :dv, :razon_social, :t_empresa_tipo_valor_id, :t_empresa_sector_economico_id, :direccion_empresa, :fax, :web, :telefono, :email)
    end

    def parametros_nueva_empresa
      params.require(:t_persona).require(:t_empresa).permit(:rif, :dv, :razon_social, :t_empresa_tipo_valor_id, :t_empresa_sector_economico_id, :direccion_empresa, :fax, :web, :telefono, :email)
    end
    
    def parametros_cliente_tipo_persona
      params.require(:t_persona).permit(:cedula, :nombre, :apellido, :t_empresa_id, :cargo, :telefono, :email, :direccion)
    end

    def parametros_cliente_tipo_otro
      params.require(:t_otro).permit(:identificacion, :razon_social, :telefono, :email, :t_tipo_persona_id)
    end

    def usar_cliente
      params.require(:t_resolucion)[:usar_cliente] == "1"
    end

    def es_prospecto
      return params.require(:t_cliente)[:es_prospecto] == "1"
    end

    def es_empresa
      params.require(:t_otro)[:t_tipo_persona_id] == "1"
    end
    
    def es_persona
      params.require(:t_otro)[:t_tipo_persona_id] == "2"
    end

    def parametros_resolucion
      datos = params.require(:t_resolucion).permit(:descripcion, :t_estatus_id, :codigo, :num_licencia, :t_cliente_id, :t_tipo_cliente_id, :resolucion)
      if (params[:t_resolucion][:resolucion] == nil)
        resolucion_codigo = params[:t_resolucion][:resolucion_codigo]
        if resolucion_codigo
          value = resolucion_codigo.strip()[0..5]
          resolucion_codigo = "#{"0"*(6-value.length)}#{value}"
        end
        datos[:resolucion] = "SMV-#{resolucion_codigo}-#{params[:t_resolucion][:resolucion_anio]}"
      end
      return datos
    end

    def parametros_contacto
      params.require(:t_contacto).permit(:nombre, :apellido, :telefono, :direccion, :email, :empresa)
    end

    def parametros_de_busqueda
      params.permit(:attribute, :search)
    end

    def usar_dataTables_en
      @usar_dataTables = true
    end

    def dataTables_resolucion
      @attributes_to_display = [
        :resolucion,
        :descripcion,
        :created_at,
      ]
    end

    def authorize_user_to_read_reports
      authorize! :read_reports, TCliente
    end

    # def clients_with_resolutions
    #   @clients_with_resolutions = TCliente.joins("INNER JOIN t_resolucions ON t_resolucions.t_cliente_id = t_clientes.id").distinct
    # end

    # def companies_with_clients_with_resolutions
    #   @companies_with_clients_with_resolutions = TEmpresa.where(t_cliente: TCliente.joins("INNER JOIN t_resolucions ON t_resolucions.t_cliente_id = t_clientes.id")).distinct
    # end

end
