class TTipoClientesController < ApplicationController
  before_action :seleccionar_tipo_cliente, only: [:show, :edit, :update, :destroy]

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
        format.html { render :edit }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy    
    @registro.estatus = 0

    if @registro.save
      format.html { redirect_to t_tipo_clientes_url, notice: 'Tipo de cliente inhabilitado correctamente.' }
      format.json { head :no_content }
    else
      format.html { render :new }
      format.json { render json: @registro.errors, status: :unprocessable_entity }
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
