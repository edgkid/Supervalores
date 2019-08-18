class TEmpresaSectorEconomicosController < ApplicationController
  before_action :seleccionar_sector_economico, only: [:show, :edit, :update, :destroy]

  #load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
		redirect_to dashboard_access_denied_path, :alert => exception.message
	end

  def index
    @usar_dataTables = true
    @registros = TEmpresaSectorEconomico.all
  end

  def show
  end

  def new
    @registro = TEmpresaSectorEconomico.new
  end

  def edit
  end

  def create
    authorize! :create, @registro
    @registro = TEmpresaSectorEconomico.new(parametros_sector_economico)

    respond_to do |format|
      if @registro.save
        format.html { redirect_to @registro, notice: 'Sector económico creado correctamente.' }
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
      if @registro.update(parametros_sector_economico)
        format.html { redirect_to @registro, notice: 'Sector económico actualizado correctamente.' }
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
    respond_to do |format|
      if @registro.save
        format.html { redirect_to t_empresa_sector_economicos_url, notice: 'Sector económico inhabilitado correctamente.' }
        format.json { head :no_content }
      else
        @notice = @registro.errors
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def seleccionar_sector_economico
      @registro = TEmpresaSectorEconomico.find(params[:id])
    end

    def parametros_sector_economico
      params.require(:t_empresa_sector_economico).permit(:descripcion, :estatus)
    end
end
