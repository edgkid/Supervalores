class TTipoEmisionsController < ApplicationController
  before_action :seleccionar_tipo_persona, only: [:show, :edit, :update, :destroy]

  # load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
		redirect_to dashboard_access_denied_path, :alert => exception.message
	end

  def index
    @usar_dataTables = true
    @registros = TTipoEmision.all
  end

  def show
  end

  def new
    @registro = TTipoEmision.new
  end

  def edit
  end

  def create
    @registro = TTipoEmision.new(parametros_tipo_persona)

    respond_to do |format|
      if @registro.save
        format.html { redirect_to @registro, notice: 'Tipo de emision creado correctamente.' }
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
      if @registro.update(parametros_tipo_persona)
        format.html { redirect_to @registro, notice: 'Tipo de emision actualizado correctamente.' }
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
        format.html { redirect_to t_tipo_personas_url, notice: 'Tipo de emision inhabilitado correctamente.' }
        format.json { head :no_content }
      else
        @notice = @registro.errors
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def seleccionar_tipo_persona
      @registro = TTipoEmision.find(params[:id])
    end

    def parametros_tipo_persona
      params.require(:t_tipo_persona).permit(:descripcion, :estatus)
    end
end
