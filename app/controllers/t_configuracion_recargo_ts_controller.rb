class TConfiguracionRecargoTsController < ApplicationController
  before_action :set_t_configuracion_recargo_ts, only: [:show, :edit, :update, :destroy]

  def new
    @t_configuracion_recargo_ts = TConfiguracionRecargoT.new
  end

  def create
    @t_configuracion_recargo_ts = TConfiguracionRecargoT.new(t_configuracion_recargo_t_params)

    if @t_configuracion_recargo_ts.save
      redirect_to @t_configuracion_recargo_ts, notice: 'Configuración de Recargo TS creada correctamente.'
    else
      @notice = @t_configuracion_recargo_ts.errors
      render 'new'
    end
  end

  def edit
  end

  def show
  end

  def update
    if @t_configuracion_recargo_ts.update(t_configuracion_recargo_t_params)
      redirect_to @t_configuracion_recargo_ts, notice: 'Configuración de Recargo TS actualizada correctamente.'
    else
      @notice = @t_configuracion_recargo_ts.errors
      render 'edit'
    end
  end

  def destroy
    @t_configuracion_recargo_ts.destroy

    redirect_to new_t_configuracion_recargo_t_path, notice: 'Configuración de Recargo TS eliminada correctamente.'
  end

  private

    def t_configuracion_recargo_t_params
      params.require(:t_configuracion_recargo_t).permit(:nombre, :tasa)
    end

    def set_t_configuracion_recargo_ts
      @t_configuracion_recargo_ts = TConfiguracionRecargoT.find(params[:id])
    end
end
