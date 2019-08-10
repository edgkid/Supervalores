class TPeriodosController < ApplicationController
  before_action :set_t_periodo, only: [:edit, :update, :show, :destroy]

  def new
    @t_periodo = TPeriodo.new
  end

  def create
    @t_periodo = TPeriodo.new(t_periodo_params)

    if @t_periodo.save
      # flash[:success] = "Periodo creado exitosamente."
      redirect_to t_periodos_path
    else
      # flash.now[:danger] = "No se pudo crear el periodo."
      render 'new'
    end
  end

  def edit
  end

  def update
    if @t_periodo.update(t_periodo_params)
      # flash[:success] = "Periodo actualizado exitosamente."
      redirect_to t_periodos_path
    else
      # flash.now[:danger] = "No se pudo modificar el periodo."
      render 'edit'
    end
  end

  def index
    @usar_dataTables = true
    @t_periodos = TPeriodo.all
  end

  def show
  end

  def destroy
    @t_periodo.destroy

    # flash[:warning] = "Periodo eliminado."
    redirect_to t_periodos_path
  end

  private

    def t_periodo_params
      params.require(:t_periodo).permit(
        :descripcion, :rango_dias, :dia_tope,
        :mes_tope, :mes_tope_desc, :estatus
      )
    end

    def set_t_periodo
      @t_periodo = TPeriodo.find(params[:id])
    end
end
