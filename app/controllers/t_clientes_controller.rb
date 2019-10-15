class TClientesController < ApplicationController
  # include TClientesHelper

  respond_to :js, only: [:find]
  respond_to :json, only: [:find_by_codigo, :find_by_resolucion, :find_by_cedula]
  before_action :seleccionar_cliente, only: [:show, :edit, :update, :destroy, :nueva_resolucion, :nueva_empresa]
  before_action :usar_dataTables_en, only: [:index, :show, :edit]
  before_action :seleccionar_resolucion, only: [:mostrar_resolucion]
  before_action :clients_with_resolutions, only: :find_by_codigo
  before_action :companies_with_clients_with_resolutions, only: :find_by_cedula
  # load_and_authorize_resource

  def index    
    @usar_dataTables = true
    @attributes_to_display = [
      :codigo,
      :identificacion,
      :razon_social,
      :telefono,
      :email,
      :es_prospecto,
      :t_estatus,
      :tipo_persona,
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
    @usar_dataTables = true
    @do_not_use_plain_select2 = true   
    
    @attributes_to_display = [
      :numero,
      :fecha_notificacion,
      :fecha_vencimiento,
      :recargo,
      :total_factura,
      :pendiente_fact,
      :tipo
    ]

    respond_to do |format|
      format.html
      format.json { render json: EstadoCuentaDatatable.new(
        params.merge({
          attributes_to_display: @attributes_to_display,
          t_estatus_id: params[:t_estatus_id],
          t_resolucion_id: params[:t_resolucion_id]
        }),
        view_context: view_context)
      }
    end
  end

  def estado_cuenta_calculo_de_totales
    t_estatus_id = params[:t_estatus_id]
    t_resolucion_id = params[:t_resolucion_id]
    sum_total = TFactura
      .where( 
        t_estatus_id: t_estatus_id, 
        t_resolucion_id: t_resolucion_id 
      )
      .sum("t_facturas.total_factura")
    sum_pago_recibido = TFactura.left_joins(:t_recibos)
      .where( 
        t_estatus_id: t_estatus_id, 
        t_resolucion_id: t_resolucion_id 
      )
      .sum("COALESCE(t_recibos.pago_recibido, 0)")
    if t_estatus_id != "" && t_resolucion_id != ""
      render json: {
        procesado: true,
        total: sum_total,
        por_pagar: sum_total - sum_pago_recibido
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
    @registro = TCliente.new
    @registro.t_estatus_id = 2
    @registro.es_prospecto = true
  end

  def edit
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
    
    respond_to do |format|
      if @nueva_empresa != nil && @nueva_empresa.errors.any?
        @notice = @nueva_empresa.errors
        format.html { render :new }
        format.json { render json: @nueva_empresa.errors, status: :unprocessable_entity }
      elsif !@registro.persona.save
        @nueva_empresa = nil
        @notice = @registro.persona.errors
        format.html { render :new }
        format.json { render json: @registro.persona.errors, status: :unprocessable_entity }
      elsif @registro.save
        @registro.es_prospecto = es_prospecto
        if !@registro.es_prospecto
          @resolucion = TResolucion.new(parametros_resolucion)
          @resolucion.usar_cliente = usar_cliente
          @resolucion.t_cliente = @registro

          @contacto = nil                    
          if !@resolucion.usar_cliente
            @contacto = TContacto.new(parametros_contacto)
            @contacto.t_resolucion = @resolucion
            @contacto.valid?
          end

          if @contacto != nil && @contacto.errors.any?
            @notice = @contacto.errors
            format.html { render :new }
            format.json { render json: @contacto.errors, status: :unprocessable_entity }
          elsif @resolucion.errors.any?
            @notice = @resolucion.errors
            format.html { render :new }
            format.json { render json: @resolucion.errors, status: :unprocessable_entity }
          else
            @resolucion.save
            @registro.prospecto_at = Time.now
            @registro.save
            if @contacto != nil
              @contacto.t_resolucion = @resolucion
              @contacto.save
            end
            format.html { redirect_to edit_t_cliente_path(@registro), notice: 'Cliente creado y resolución asociada correctamente.' }
            format.json { render :show, status: :created, location: @registro }
          end
        end
        format.html { redirect_to edit_t_cliente_path(@registro), notice: 'Cliente creado correctamente.' }
        format.json { render :show, status: :created, location: @registro }
      else
        @notice = @registro.errors
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  def update    
    crear = false
    actualizar = false
    parametros = {}
    @nueva_empresa = nil

    respond_to do |format|      
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
      
      if @nueva_empresa != nil && @nueva_empresa.errors.any?
        @notice = @nueva_empresa.errors
        format.html { render :edit }
        format.json { render json: @nueva_empresa.errors, status: :unprocessable_entity }
      elsif (actualizar && !@registro.persona.update(parametros)) || (crear && !@registro.persona.save)
        @notice = @registro.persona.errors
        format.html { render :edit }
        format.json { render json: @registro.persona.errors, status: :unprocessable_entity }
      elsif @registro.update(parametros_cliente)
        @registro.es_prospecto = es_prospecto
        if (!@registro.es_prospecto && @registro.prospecto_at == nil)
          @resolucion = TResolucion.new(parametros_resolucion)
          @resolucion.usar_cliente = usar_cliente
          @resolucion.t_cliente = @registro
          
          @contacto = nil          
          if !usar_cliente
            @contacto = TContacto.new(parametros_contacto)
            @contacto.t_resolucion = @resolucion
            @contacto.valid?
          end
          @resolucion.valid?

          if @contacto != nil && @contacto.errors.any?
            @notice = @contacto.errors
            format.html { render :edit }
            format.json { render json: @contacto.errors, status: :unprocessable_entity }
          elsif @resolucion.errors.any?
            @notice = @resolucion.errors
            format.html { render :edit }
            format.json { render json: @contacto.errors, status: :unprocessable_entity }
          else
            @resolucion.save
            @registro.prospecto_at = Time.now
            @registro.save
            if @contacto != nil
              @contacto.t_resolucion = @resolucion
              @contacto.save
            end
            format.html { redirect_to edit_t_cliente_path(@registro), notice: 'Cliente actualizado y resolución asociada correctamente.' }
            format.json { render :show, status: :ok, location: @registro }
          end
        end
        format.html { redirect_to edit_t_cliente_path(@registro), notice: 'Cliente actualizado correctamente.' }
        format.json { render :show, status: :ok, location: @registro }
      else
        @notice = @registro.errors
        format.html { render :edit }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
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
        format.html { redirect_to edit_t_cliente_path(@registro), notice: 'Resolución asociada correctamente.' }
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
    respond_with @clients_with_resolutions.where('t_clientes.codigo ILIKE ?', "%#{search}%").first(10)
  end

  def find_by_cedula
    search = parametros_de_busqueda[:search]

    personas = TPersona.where('cedula ILIKE ?', "%#{search}%").first(10)
    if personas.empty?
      personas = @companies_with_clients_with_resolutions.where('rif ILIKE ?', "%#{search}%").first(10)
    end

    respond_with personas
    # respond_with TCliente.where('razon_social LIKE ?', "%#{search}%").first(10)
  end

  def find_by_resolucion
    search = parametros_de_busqueda[:search]
    respond_with TResolucion.where('resolucion_codigo ILIKE ?', "%#{search}%").first(10)
  end

  def find
    @attribute = parametros_de_busqueda[:attribute]
    search = parametros_de_busqueda[:search]

    case @attribute
    when 'select-codigo'
      @t_cliente = TCliente.find_by(codigo: search)

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
      @t_persona = TPersona.find_by(cedula: search)
      if @t_persona
        @t_cliente = @t_persona.t_cliente
      else
        @t_empresa = TEmpresa.find_by(rif: search)
        @t_cliente = @t_empresa.t_cliente
        @without_client = true unless @t_cliente
      end
    end if search != ''

    if @t_persona.class.to_s == 'TEmpresa'
      @t_empresa = @t_persona
      @t_persona = nil
    end
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
      params.require(:t_cliente).permit(:codigo, :dv, :t_estatus_id, :cuenta_venta, :t_tipo_persona_id, :razon_social, :telefono, :email, :es_prospecto)
    end
    
    def parametros_cliente_tipo_empresa
      params.require(:t_empresa).permit(:rif, :razon_social, :t_empresa_tipo_valor_id, :t_empresa_sector_economico_id, :direccion_empresa, :fax, :web, :telefono, :email)
    end

    def parametros_nueva_empresa
      params.require(:t_persona).require(:t_empresa).permit(:rif, :razon_social, :t_empresa_tipo_valor_id, :t_empresa_sector_economico_id, :direccion_empresa, :fax, :web, :telefono, :email)
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
      params.require(:t_cliente)[:es_prospecto] == "1"
    end

    def es_empresa
      params.require(:t_otro)[:t_tipo_persona_id] == "1"
    end
    
    def es_persona
      params.require(:t_otro)[:t_tipo_persona_id] == "2"
    end

    def parametros_resolucion
      params.require(:t_resolucion).permit(:descripcion, :t_estatus_id, :resolucion_codigo, :resolucion_anio, :codigo, :num_licencia, :t_cliente_id, :t_tipo_cliente_id)
    end

    def parametros_contacto
      params.require(:t_contacto).permit(:nombre, :apellido, :telefono, :direccion, :email, :empresa)
    end

    def parametros_de_busqueda
      params.permit(:attribute, :search)
    end

    def usar_dataTables_en
      @usar_dataTables = true
      @attributes_to_display = [
        :codigo,
        :resolucion,
        :descripcion,
        :created_at,
      ]
    end

    def clients_with_resolutions
      @clients_with_resolutions = TCliente.joins("INNER JOIN t_resolucions ON t_resolucions.t_cliente_id = t_clientes.id").distinct
    end

    def companies_with_clients_with_resolutions
      @companies_with_clients_with_resolutions = TEmpresa.where(t_cliente: TCliente.joins("INNER JOIN t_resolucions ON t_resolucions.t_cliente_id = t_clientes.id")).distinct
    end

end
