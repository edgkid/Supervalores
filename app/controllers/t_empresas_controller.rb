class TEmpresasController < ApplicationController
  before_action :seleccionar_empresa, only: [:show, :edit, :update, :destroy]

  ##load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
		redirect_to dashboard_access_denied_path, :alert => exception.message
	end

  def index
    @usar_dataTables = true
    @registros = TEmpresa.all
  end

  def show
  end

  def new
    @registro = TEmpresa.new
  end

  def edit
  end

  def create
    @registro = TEmpresa.new(parametros_empresa)

    respond_to do |format|
      if @registro.save
        format.html { redirect_to @registro, notice: 'Empresa creada correctamente.' }
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
      if @registro.update(parametros_empresa)
        format.html { redirect_to @registro, notice: 'Empresa actualizada correctamente.' }
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
    respond_to do |format|
      if @registro.save
        format.html { redirect_to t_empresas_url, notice: 'Empresa inhabilitada correctamente.' }
        format.json { head :no_content }
      else
        @notice = @registro.errors
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def seleccionar_empresa
      @registro = TEmpresa.find(params[:id])
    end

    def parametros_empresa
      params.require(:t_empresa).permit(:rif, :razon_social, :tipo_valor, :sector_economico, :direccion_empresa, :fax, :web, :telefono, :email)
    end
end
