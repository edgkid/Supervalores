class TClientesController < ApplicationController
  before_action :set_t_cliente, only: [:show, :edit, :update, :destroy]

  def index
    @registros = TCliente.all
  end

  def show
  end

  def new
    @registro = TCliente.new
  end

  def edit
  end

  def create
    @registro = TCliente.new(t_cliente_params)

    respond_to do |format|
      if @registro.save
        format.html { redirect_to @registro, notice: 'T cliente was successfully created.' }
        format.json { render :show, status: :created, location: @registro }
      else
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @registro.update(t_cliente_params)
        format.html { redirect_to @registro, notice: 'T cliente was successfully updated.' }
        format.json { render :show, status: :ok, location: @registro }
      else
        format.html { render :edit }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @registro.destroy
    respond_to do |format|
      format.html { redirect_to t_clientes_url, notice: 'T cliente was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_t_cliente
      @registro = TCliente.find(params[:id])
    end

    def t_cliente_params
      params.require(:t_cliente).permit(:codigo, :t_estatus_id, :cuenta_venta, :t_tipo_cliente_id, :t_tipo_persona_id, :user_id, :razon_social, :telefono, :email, :prospecto_at)
    end
end
