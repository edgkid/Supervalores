class TTarifasController < ApplicationController
  before_action :set_t_tarifa, only: [:edit, :update, :show, :destroy]

  def new
    @t_tarifa = TTarifa.new
  end

  def create
    @t_tarifa = TTarifa.new(t_tarifa_params)

    if @t_tarifa.save
      # flash[:success] = "Tarifa creada exitosamente."
      redirect_to t_tarifas_path
    else
      # flash.now[:danger] = "No se pudo crear la tarifa."
      render 'new'
    end
  end

  def edit
  end

  def update
    if @t_tarifa.update(t_tarifa_params)
      # flash[:success] = "Tarifa actualizada exitosamente."
      redirect_to t_tarifas_path
    else
      # flash.now[:danger] = "No se pudo modificar la tarifa."
      render 'edit'
    end
  end

  def index
    @usar_dataTables = true
    @t_tarifas = TTarifa.all
  end

  def show
  end

  def destroy
    @t_tarifa.destroy

    # flash[:warning] = "Tarifa eliminada."
    redirect_to t_tarifas_path
  end

  private

    def t_tarifa_params
      params.require(:t_tarifa).permit(
        :nombre, :descripcion, :rango_monto,
        :recargo, :estatus
      )
    end

    def set_t_tarifa
      @t_tarifa = TTarifa.find(params[:id])
    end
end
