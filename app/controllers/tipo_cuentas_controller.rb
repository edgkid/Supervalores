class TipoCuentasController < ApplicationController

    before_action :set_uenta, only: [:show, :edit, :update, :destroy]

  def index
  end

  def new
    @cuenta = TTipoCuenta.new
  end

  def create
    @cuenta = TTipoCuenta.new(cuenta_params)

    @cuenta.estatus = params[:is_active] == "Activo"? true : false

    if @cuenta.save
        redirect_to tipo_cuentas_index_path, notice: 'Tipo de cuenta creada correctamente.'
    else
      @notice = @cuenta.errors
      render :action => "new"
    end
  end

  def update
  end

  private
    def set_user
      @cuenta = TTipoCuenta.find(params[:id])
    end

    def cuenta_params
      params.require(:cuenta).permit(:descripcion, :estatus)
    end

end
