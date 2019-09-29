class TTarifaServiciosController < ApplicationController
  before_action :set_t_tarifa_servicio, only: [:edit, :update, :show, :destroy]

  load_and_authorize_resource

  def new
    @t_tarifa_servicio = TTarifaServicio.new
  end

  def create
    @t_tarifa_servicio = TTarifaServicio.new(t_tarifa_servicio_params)

    if @t_tarifa_servicio.save!
      # flash[:success] = "TarifaServicio creado exitosamente."
      redirect_to t_tarifa_servicios_path
    else
      # flash.now[:danger] = "No se pudo crear el tarifa_servicio."
      render 'new'
    end
  end

  def edit
  end

  def update
    if @t_tarifa_servicio.update(t_tarifa_servicio_params)
      # flash[:success] = "TarifaServicio actualizado exitosamente."
      redirect_to t_tarifa_servicios_path
    else
      # flash.now[:danger] = "No se pudo modificar el tarifa_servicio."
      render 'edit'
    end
  end

  def index
    @usar_dataTables = true
    @attributes_to_display = [
      :codigo, :descripcion, :nombre,
      :clase, :precio, :estatus
    ]

    respond_to do |format|
      format.html
      format.json { render json: ApplicationDatatable.new(
        params.merge({
          attributes_to_display: @attributes_to_display
        }),
        view_context: view_context)
      }
    end
  end

  def show
  end

  def destroy
    @t_tarifa_servicio.destroy

    # flash[:warning] = "TarifaServicio eliminado."
    redirect_to t_tarifa_servicios_path
  end

  private

    def t_tarifa_servicio_params
      params.require(:t_tarifa_servicio).permit(
        :codigo, :descripcion, :nombre,
        :clase, :precio, :estatus
      )
    end

    def set_t_tarifa_servicio
      @t_tarifa_servicio = TTarifaServicio.find(params[:id])
    end
end
