class TClientesController < ApplicationController
  respond_to :js, only: [:find]
  respond_to :json, only: [:find_by_codigo, :find_by_resolucion, :find_by_razon_social]
  before_action :seleccionar_cliente, only: [:show, :edit, :update, :destroy, :nueva_resolucion]  
  before_action :usar_dataTables_en, only: [:index, :show, :edit]

  def index
    @registros = TCliente.all
  end

  def show
  end

  def new
    @registro = TCliente.new
    @registro.es_prospecto = true
  end

  def edit
  end

  def create
    @registro = TCliente.new(parametros_cliente)
    respond_to do |format|
      if @registro.save
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
            format.json { render json: @registro.errors, status: :unprocessable_entity }
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
    respond_to do |format|      
      if @registro.update(parametros_cliente)
        @registro.es_prospecto = es_prospecto
        if (!@registro.es_prospecto && @registro.prospecto_at == nil)
          @resolucion = TResolucion.new(parametros_resolucion)
          @resolucion.t_cliente = @registro
          if @resolucion.save
            @registro.prospecto_at = Time.now
            @registro.save
            format.html { redirect_to @registro, notice: 'Cliente actualizado y resolución asociada correctamente.' }
            format.json { render :show, status: :ok, location: @registro }
          else
            @notice = @resolucion.errors
            format.html { render :edit }
            format.json { render json: @registro.errors, status: :unprocessable_entity }
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
        format.json { render :show, status: :ok, location: @registro }
      else
        @notice = @nueva_resolucion.errors
        format.html { render :edit }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy 
    @registro.t_estatus = TEstatus.find_by(descripcion: "Inactivo")
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

  def find_by_razon_social
    search = parametros_de_busqueda[:search]
    respond_with TCliente.where('razon_social LIKE ?', "%#{search}%").first(10)
  end

  def find
    @attribute = parametros_de_busqueda[:attribute]
    search = parametros_de_busqueda[:search]

    @t_cliente =  case @attribute
                  when 'select-codigo'
                    TCliente.find_by(codigo: search)
                  when 'select-resolucion'
                    @t_resolucion = TResolucion.find_by(resolucion: search)
                    @t_resolucion.t_cliente
                  when 'select-razon_social'
                    TCliente.find_by(razon_social: search)
                  end if search != ''
  end

  private
    def seleccionar_cliente
      @registro = TCliente.find(params[:id])
      @registro.es_prospecto = @registro.prospecto_at == nil
    end

    def parametros_cliente
      params.require(:t_cliente).permit(:codigo, :t_estatus_id, :cuenta_venta, :t_tipo_cliente_id, :t_tipo_persona_id, :razon_social, :telefono, :email, :es_prospecto)
    end

    def es_prospecto
      params.require(:t_cliente)[:es_prospecto] == "1"
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
