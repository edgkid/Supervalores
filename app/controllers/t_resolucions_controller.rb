class TResolucionsController < ApplicationController
  before_action :seleccionar_resolucion, only: [:show, :edit, :update, :destroy]

  def index
    @usar_dataTables = true
    @registros = TResolucion.all
  end

  def show
  end

  def new
    @registro = TResolucion.new
  end

  def edit
  end

  def create
    @registro = TResolucion.new(parametros_resolucion)

    respond_to do |format|
      if @registro.save
        format.html { redirect_to @registro, notice: 'Resolución creado correctamente.' }
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
      if @registro.update(parametros_resolucion)
        format.html { redirect_to @registro, notice: 'Resolución actualizado correctamente.' }
        format.json { render :show, status: :ok, location: @registro }
      else
        @notice = @registro.errors
        format.html { render :edit }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @registro.save.t_estatus = TEstatus.find_by(description: "Inactivo")
    if @registro.save
      format.html { redirect_to t_tipo_clientes_url, notice: 'Tipo de cliente inhabilitado correctamente.' }
      format.json { head :no_content }
    else
      @notice = @registro.errors
      format.html { render :new }
      format.json { render json: @registro.errors, status: :unprocessable_entity }
    end
  end

  private
    def seleccionar_resolucion
      @registro = TResolucion.find(params[:id])
    end

    def parametros_resolucion
      params.require(:t_resolucion).permit(:descripcion, :t_cliente_id, :t_estatus_id, :resolucion)
    end
end
