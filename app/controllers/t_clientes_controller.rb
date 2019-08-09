class TClientesController < ApplicationController
  respond_to :js, only: :buscar
  before_action :seleccionar_cliente, only: [:show, :edit, :update, :destroy]  

  def index    
    @notice = "Estos son los clientes reistrados en el sistema" 
    @usar_dataTables = true
    @registros = TCliente.all
  end

  def show
    @notice = Notice.new("Perfil de "+@registro.razon_social, "Genial! no?", :info)
  end

  def new
    @registro = TCliente.new    
  end

  def edit
    @notice = Notice.new("Perfil de "+@registro.razon_social, "Cuidado con lo que cambias!", :warning)
  end

  def create
    @registro = TCliente.new(parametros_cliente)
    @registro.prospecto_at = Time.now   
    
    respond_to do |format|
      if @registro.save        
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
        format.html { redirect_to @registro, notice: 'Cliente actualizado correctamente.' }
        format.json { render :show, status: :ok, location: @registro }
      else
        @notice = @registro.errors
        format.html { render :edit }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy 
    @registro.estatus = 0

    if @registro.save
      format.html { redirect_to t_clientes_url, notice: 'Cliente inhabilitado correctamente.' }
      format.json { head :no_content }
    else
      @notice = @registro.errors
      format.html { render :new }
      format.json { render json: @registro.errors, status: :unprocessable_entity }
    end
  end

  def buscar
    attribute = parametros_de_busqueda[:attribute]
    value = parametros_de_busqueda[:value]

    case attribute
    when 'codigo'
      @t_clientes = TCliente.where('codigo LIKE ?', "%#{value}%")
    when 'resolucion'
      @t_resolucions = TResolucion.where('resolucion LIKE ?', "%#{value}%")
    when 'razon_social'
      @t_clientes = TCliente.where('razon_social LIKE ?', "%#{value}%")
    end if value != ''
  end

  private
    def seleccionar_cliente
      @registro = TCliente.find(params[:id])
    end

    def parametros_cliente
      params.require(:t_cliente).permit(:codigo, :t_estatus_id, :cuenta_venta, :t_tipo_cliente_id, :t_tipo_persona_id, :razon_social, :telefono, :email)
    end

    def parametros_de_busqueda
      params.permit(:attribute, :value)
    end

end
