class TEmisionsController < ApplicationController
  before_action :seleccionar_emision, only: [:show, :edit, :update, :destroy]

  # load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
		redirect_to dashboard_access_denied_path, :alert => exception.message
	end

  def index
    @usar_dataTables = true
    @registros = TEmision.all
  end

  def show
  end

  def new
    @registro = TEmision.new
  end

  def edit
  end

  def create
    @registro = TEmision.new(parametros_emision)
    @registro.user = current_user

    respond_to do |format|
      if @registro.save
        format.html { redirect_to @registro, notice: 'Emisión creada correctamente.' }
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
      if @registro.update(parametros_emision)
        format.html { redirect_to @registro, notice: 'Emisión actualizada correctamente.' }
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
        format.html { redirect_to t_emisions_url, notice: 'Emisión inhabilitada correctamente.' }
        format.json { head :no_content }
      else
        @notice = @registro.errors
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def seleccionar_emision
      @registro = TEmision.find(params[:id])
    end

    def parametros_emision
      params.require(:t_emision).permit(:fecha_emision, :valor_circulacion, :tasa, :monto_pagar, :estatus, :t_periodo_id, :t_tipo_emision_id, :user_id)
    end
end
