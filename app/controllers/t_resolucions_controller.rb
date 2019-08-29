class TResolucionsController < ApplicationController
  before_action :seleccionar_resolucion, only: [:show, :edit, :update, :destroy]

  # load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
		redirect_to dashboard_access_denied_path, :alert => exception.message
	end

  def index
    @usar_dataTables = true
    @registros = TResolucion.all
  end

  def show
  end

  def new
    @registro = TResolucion.new
  end

  def edit
  end

  def create
    @registro = TResolucion.new(parametros_resolucion)
    @registro.usar_cliente = usar_cliente    
          
    @contacto = nil          
    if !usar_cliente
      @contacto = TContacto.new(parametros_contacto)
      @contacto.t_resolucion = @registro
      @contacto.valid?
    end
    @registro.valid?

    respond_to do |format|
      if @contacto != nil && @contacto.errors.any?
        @notice = @contacto.errors
        format.html { render :new }
        format.json { render json: @contacto.errors, status: :unprocessable_entity }
      elsif @registro.errors.any?
        @notice = @registro.errors
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      else
        format.html { redirect_to @registro, notice: 'Resolución creada correctamente.' }
        format.json { render :show, status: :created, location: @registro }
      end
    end
  end

  def update    
    @registro.usar_cliente = usar_cliente

    @contacto = nil          
    if !usar_cliente
      @contacto = TContacto.new(parametros_contacto)
      @contacto.t_resolucion = @registro
      @contacto.valid?
    elsif @registro.t_contacto != nil
      @registro.t_contacto.destroy
    end
    @registro.valid?

    respond_to do |format|
      if @contacto != nil && @contacto.errors.any?
        @notice = @contacto.errors
        format.html { render :new }
        format.json { render json: @contacto.errors, status: :unprocessable_entity }
      elsif @registro.update(parametros_resolucion)
        format.html { redirect_to @registro, notice: 'Resolución actualizada correctamente.' }
        format.json { render :show, status: :ok, location: @registro }
      else
        @notice = @registro.errors
        format.html { render :edit }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @registro.t_estatus = TEstatus.find(1)
    respond_to do |format|
      if @registro.save
        format.html { redirect_to t_resolucions_url, notice: 'Resolución inhabilitada correctamente.' }
        format.json { head :no_content }
      else
        @notice = @registro.errors
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def seleccionar_resolucion
      @registro = TResolucion.find(params[:id])
      @registro.usar_cliente = @registro.t_contacto == nil
    end

    def parametros_resolucion
      params.require(:t_resolucion).permit(:descripcion, :t_cliente_id, :t_estatus_id, :resolucion_codigo, :resolucion_anio, :t_tipo_cliente_id)
    end
    
    def parametros_contacto
      params.require(:t_contacto).permit(:nombre, :apellido, :telefono, :direccion, :email, :empresa)
    end
    
    def usar_cliente
      params.require(:t_resolucion)[:usar_cliente] == "1"
    end
end
