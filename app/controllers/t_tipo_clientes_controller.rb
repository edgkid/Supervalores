class TTipoClientesController < ApplicationController
  before_action :seleccionar_tipo_cliente, only: [:show, :edit, :update, :destroy]

  def index
    @usar_dataTables = true
    @registros = TTipoCliente.all
  end

  def redirect  
    @registro = TTipoCliente.take  
    redirect_to @registro, notice: 'Tipo cliente creado correctamente.'
    #redirect_to :t_tipo_clientes, notice: 'Tipo cliente creado correctamente.', type: :success
  end

  def show
  end

  def new
    @registro = TTipoCliente.new
  end

  def edit
  end

  def create
    @registro = TTipoCliente.new(t_tipo_cliente_params)

    respond_to do |format|
      if @registro.save
        format.html { redirect_to @registro, notice: 'Tipo cliente creado correctamente.' }
        format.json { render :show, status: :created, location: @registro }
      else
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @registro.update(t_tipo_cliente_params)
        format.html { redirect_to @registro, notice: 'Tipo cliente actualizado correctamente.' }
        format.json { render :show, status: :ok, location: @registro }
      else
        format.html { render :edit }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    #@registro.destroy
    @registro.estatus = 0
    if @registro.save
      respond_to do |format|
        format.html { redirect_to t_tipo_clientes_url, notice: 'Tipo de cliente inhabilitado correctamente.' }
        format.json { head :no_content }
      end
    else
      format.html { render :new }
      format.json { render json: @registro.errors, status: :unprocessable_entity }
    end
    
  end

  private
    def seleccionar_tipo_cliente
      @registro = TTipoCliente.find(params[:id])
    end

    def t_tipo_cliente_params
      params.require(:t_tipo_cliente).permit(:codigo, :descripcion, :tipo, :estatus, :t_tarifa_id)
    end
end
