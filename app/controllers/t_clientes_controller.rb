class TClientesController < ApplicationController
  include TClientesHelper

  respond_to :js, only: [:find]
  respond_to :json, only: [:find_by_codigo, :find_by_resolucion, :find_by_cedula]
  before_action :seleccionar_cliente, only: [:show, :edit, :update, :destroy, :nueva_resolucion, :nueva_empresa]
  before_action :usar_dataTables_en, only: [:index, :show, :edit]
  before_action :seleccionar_resolucion, only: [:mostrar_resolucion]
  # load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
		redirect_to dashboard_access_denied_path	, :alert => exception.message
	end

  def index
    @registros = list_clientes
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
          @resolucion.t_cliente = @registro
          if @resolucion.save
            @registro.prospecto_at = Time.now
            @registro.save
            format.html { redirect_to @registro, notice: 'Cliente creado y resolución asociada correctamente.' }
            format.json { render :show, status: :created, location: @registro }
          else
            @notice = @resolucion.errors
            format.html { render :new }
            format.json { render json: @resolucion.errors, status: :unprocessable_entity }
          end
        end
        format.html { redirect_to @registro, notice: 'Cliente creado correctamente.' }
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
          @resolucion.t_cliente = @registro
          if @resolucion.save
            @registro.prospecto_at = Time.now
            @registro.save
            format.html { redirect_to edit_t_cliente_path(@registro), notice: 'Cliente actualizado y resolución asociada correctamente.' }
            format.json { render :show, status: :ok, location: @registro }
          else
            @notice = @resolucion.errors
            format.html { render :edit }
            format.json { render json: @resolucion.errors, status: :unprocessable_entity }
          end
        end
        format.html { redirect_to @registro, notice: 'Cliente actualizado correctamente.' }
        format.json { render :show, status: :ok, location: @registro }
      else
        @notice = @registro.errors
        format.html { render :edit }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  def nueva_resolucion
    @nueva_resolucion = TResolucion.new(parametros_resolucion)
    respond_to do |format|
      if @nueva_resolucion.save
        format.html { redirect_to edit_t_cliente_path(@registro), notice: 'Resolución asociada correctamente.' }
        format.json { render :show, status: :ok, location: @nueva_resolucion }
      else
        @notice = @nueva_resolucion.errors
        format.html { render :edit }
        format.json { render json: @nueva_resolucion.errors, status: :unprocessable_entity }
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
    respond_with TCliente.where('codigo LIKE ?', "%#{search}%").first(10)
  end

  def find_by_resolucion
    search = parametros_de_busqueda[:search]
    respond_with TResolucion.where('resolucion LIKE ?', "%#{search}%").first(10)
  end

  def find_by_cedula
    search = parametros_de_busqueda[:search]

    personas = TPersona.where('cedula LIKE ?', "%#{search}%").first(10)
    if personas.empty?
      personas = TEmpresa.where('rif LIKE ?', "%#{search}%").first(10)
    end

    respond_with personas
    # respond_with TCliente.where('razon_social LIKE ?', "%#{search}%").first(10)
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
      @t_resolucion = TResolucion.find_by(resolucion: search)
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
  end

  private
    def seleccionar_cliente
      @registro = TCliente.find(params[:id])
      @registro.es_prospecto = @registro.prospecto_at == nil
    end

    def seleccionar_resolucion
      @mostrar_resolucion = TResolucion.find(params[:resolucion])
    end

    def parametros_cliente
      params.require(:t_cliente).permit(:codigo, :t_estatus_id, :cuenta_venta, :t_tipo_cliente_id, :t_tipo_persona_id, :razon_social, :telefono, :email, :es_prospecto)
    end
    
    def parametros_cliente_tipo_empresa
      params.require(:t_empresa).permit(:rif, :razon_social, :t_empresa_tipo_valor_id, :t_empresa_sector_economico_id, :direccion_empresa, :fax, :web, :telefono, :email)
    end

    def parametros_nueva_empresa
      params.require(:t_persona).require(:t_empresa).permit(:rif, :razon_social, :t_empresa_tipo_valor_id, :t_empresa_sector_economico_id, :direccion_empresa, :fax, :web, :telefono, :email)
    end
    
    def parametros_cliente_tipo_persona
      params.require(:t_persona).permit(:cedula, :nombre, :apellido, :num_licencia, :t_empresa_id, :cargo, :telefono, :email)
    end

    def parametros_cliente_tipo_otro
      params.require(:t_otro).permit(:identificacion, :razon_social, :telefono, :email, :t_tipo_persona_id)
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
      params.require(:t_resolucion).permit(:descripcion, :t_estatus_id, :resolucion, :t_cliente_id)
    end

    def parametros_de_busqueda
      params.permit(:attribute, :search)
    end

    def usar_dataTables_en
      @usar_dataTables = true
    end
end
