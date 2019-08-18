class TRecargosController < ApplicationController
  before_action :seleccionar_recargo, only: [:show, :edit, :update, :destroy]

  # load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
		redirect_to dashboard_access_denied_path, :alert => exception.message
	end

  def index
    @usar_dataTables = true
    @registros = TRecargo.all
  end

  def show
  end

  def new
    @registro = TRecargo.new
  end

  def edit
  end

  def create
    @registro = TRecargo.new(parametros_recargo)
    respond_to do |format|
      if @registro.save
        format.html { redirect_to @registro, notice: 'Recargo creado correctamente.' }
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
      if @registro.update(parametros_recargo)
        format.html { redirect_to @registro, notice: 'Recargo actualizado correctamente.' }
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
        format.html { redirect_to t_tipo_clientes_url, notice: 'Recargo inhabilitado correctamente.' }
        format.json { head :no_content }
      else
        @notice = @registro.errors
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  def find_by_descripcion
    search = search_params[:search]
    respond_with TRecargo.where('descripcion LIKE ?', "%#{search}%").first(10)
  end

  private
    def seleccionar_recargo
      @registro = TRecargo.find(params[:id])
    end

    def parametros_recargo
      params.require(:t_recargo).permit(:descripcion, :tasa, :estatus, :factura_id)
    end

    def search_params
      params.permit(:search)
    end
end
