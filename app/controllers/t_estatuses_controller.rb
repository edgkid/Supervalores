class TEstatusesController < ApplicationController
  before_action :seleccionar_estatus, only: [:show, :edit, :update, :destroy]

  #load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
		redirect_to dashboard_access_denied_path, :alert => exception.message
	end

  def index
    @usar_dataTables = true
    @registros = TEstatus.all
  end

  def show
  end

  def new
    @registro = TEstatus.new
  end

  def edit
  end

  def create

    authorize! :create, @registro
    @registro = TEstatus.new(parametros_estatus)

    respond_to do |format|
      if @registro.save
        format.html { redirect_to @registro, notice: 'Estatus creado correctamente.' }
        format.json { render :show, status: :created, location: @registro }
      else
        @notice = @registro.errors
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  def update

    authorize! :update, @registro
    respond_to do |format|
      if @registro.update(parametros_estatus)
        format.html { redirect_to @registro, notice: 'Estatus actualizado correctamente.' }
        format.json { render :show, status: :ok, location: @registro }
      else
        @notice = @registro.errors
        format.html { render :edit }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy

    authorize! :destroy, @registro
    @registro.estatus = 0

    if @registro.save
      format.html { redirect_to t_tipo_clientes_url, notice: 'Estatus inhabilitado correctamente.' }
      format.json { head :no_content }
    else
      @notice = @registro.errors
      format.html { render :new }
      format.json { render json: @registro.errors, status: :unprocessable_entity }
    end
  end

  private
    def seleccionar_estatus
      @registro = TEstatus.find(params[:id])
    end

    def parametros_estatus
      params.require(:t_estatus).permit(:estatus, :para, :descripcion, :color)
    end
end
