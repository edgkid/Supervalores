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
    respond_to do |format|
      if @registro.save
        format.html { redirect_to @registro, notice: 'Resolución creada correctamente.' }
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
      if @registro.update(parametros_resolucion)
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
    end

    def parametros_resolucion
      params.require(:t_resolucion).permit(:descripcion, :t_cliente_id, :t_estatus_id, :resolucion_codigo, :resolucion_anio)
    end
end
