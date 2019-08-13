class TipoCuentasController < ApplicationController

    before_action :set_cuenta, only: [:show, :edit, :update, :destroy]

  def index
    @cuentas = TTipoCuenta.all
  end

  def new
    @cuenta = TTipoCuenta.new
  end

  def create
    @cuenta = TTipoCuenta.new(cuenta_params)

    @cuenta.estatus = params[:is_active] == "Activo"? 1 : 0

    if @cuenta.save
        redirect_to tipo_cuentas_index_path, notice: 'Tipo de cuenta creada correctamente.'
    else
      @notice = @cuenta.errors
      render :action => "new"
    end
  end

  def edit
    @cuenta = TTipoCuenta.find(params[:id])
  end

  def update
    if params[:is_active] == "Activo" or params[:is_active] == "Inactivo"
      @cuenta.estatus = params[:is_active] == "Activo"? 1 : 0
    end

    if @cuenta.update(cuenta_params)
      redirect_to tipo_cuentas_index_path, notice: 'Tipo de cuenta actualizada correctamente.'
    else
      @notice = @cuenta.errors
      render :action => "edit"
    end
  end

  private
    def set_cuenta
      @cuenta = TTipoCuenta.find(params[:id])
    end

    def cuenta_params
      params.require(:cuenta).permit(:descripcion, :estatus)
    end

end
