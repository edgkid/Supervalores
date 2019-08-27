class TContactosController < ApplicationController
  before_action :seleccionar_contacto, only: [:show, :edit, :update, :destroy]

  # load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
		redirect_to dashboard_access_denied_path, :alert => exception.message
	end

  def index
    @usar_dataTables = true
    @registros = TContacto.all
  end

  def show
  end

  def new
    @registro = TContacto.new
  end

  def edit
  end

  def create
    @registro = TContacto.new(parametros_contacto)
    respond_to do |format|
      if @registro.save
        format.html { redirect_to @registro, notice: 'Contacto creado correctamente.' }
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
      if @registro.update(parametros_contacto)
        format.html { redirect_to @registro, notice: 'Contacto actualizado correctamente.' }
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
        format.html { redirect_to t_contactos_url, notice: 'Contacto inhabilitado correctamente.' }
        format.json { head :no_content }
      else
        @notice = @registro.errors
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def seleccionar_contacto
      @registro = TContacto.find(params[:id])
    end

    def parametros_contacto
      params.require(:t_contacto).permit(:descripcion, :t_cliente_id, :t_estatus_id, :contacto_codigo, :contacto_anio)
    end
end
