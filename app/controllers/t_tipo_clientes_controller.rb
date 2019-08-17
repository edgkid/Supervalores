class TTipoClientesController < ApplicationController
  before_action :seleccionar_tipo_cliente, only: [:show, :edit, :update, :destroy]

  # load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
		redirect_to dashboard_access_denied_path, :alert => exception.message
	end

  def index
    @usar_dataTables = true
    @registros = TTipoCliente.all
  end

  def show
  end

  def new
    @registro = TTipoCliente.new
  end

  def edit
  end

  def create
    @registro = TTipoCliente.new(parametros_tipo_cliente)

    respond_to do |format|
      if @registro.save
        format.html { redirect_to @registro, notice: 'Tipo de cliente creado correctamente.' }
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
      if @registro.update(parametros_tipo_cliente)
        format.html { redirect_to @registro, notice: 'Tipo de cliente actualizado correctamente.' }
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
        format.html { redirect_to t_tipo_clientes_url, notice: 'Tipo de cliente inhabilitado correctamente.' }
        format.json { head :no_content }
      else
        @notice = @registro.errors
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def seleccionar_tipo_cliente
      @registro = TTipoCliente.find(params[:id])
    end

    def parametros_tipo_cliente
      params.require(:t_tipo_cliente).permit(:codigo, :descripcion, :tipo, :estatus, :t_tarifa_id)
    end
end
