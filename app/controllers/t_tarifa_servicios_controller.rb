class TTarifaServiciosController < ApplicationController
  before_action :set_t_tarifa_servicio, only: [:edit, :update, :show, :destroy]
  respond_to :json, only: [:all_services]
  load_and_authorize_resource except: [:tramites]
  
  
  def estadistica_cuentas_x_cobrar
    @usar_dataTables = true
    @useDataTableFooter = false
    @do_not_use_plain_select2 = true
    @attributes_to_display = [
      :codigo_nombre,
      :total_cantidad,
      :total_monto,
      :anio,
      :anio_cantidad,
      :anio_monto
    ]

    respond_to do |format|
      format.html
      format.json { render json: EstadisticaDeCuentasXCobrarDatatable.new(
        params.merge({
          attributes_to_display: @attributes_to_display
        }),
        view_context: view_context)
      }
    end
  end
  
  def informe_tramites_tarifas_registradas
    @usar_dataTables = true
    @useDataTableFooter = false
    @do_not_use_plain_select2 = true
    @attributes_to_display = [
      :codigo_nombre,
      :total_cantidad,
      :total_monto,
      :anio,
      :anio_cantidad,
      :anio_monto
    ]

    respond_to do |format|
      format.html
      format.json { render json: InformeTramitesTarifasRegistradasDatatable.new(
        params.merge({
          attributes_to_display: @attributes_to_display
        }),
        view_context: view_context)
      }
    end
  end

  def all_services
    search = parametros_de_busqueda[:search]
    respond_with TTarifaServicio.where("
      tipo ILIKE ? OR codigo ILIKE ? OR nombre ILIKE ? OR descripcion ILIKE ?",
      "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%"
    ).first(20)
  end

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
      :codigo, :tipo, :descripcion, :nombre,
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

  def tramites
    @usar_dataTables = true
    # @useDataTableFooter = true
    @do_not_use_plain_select2 = true
    @no_cache = true

    @attributes_to_display = [
      :fecha, :cantidad, :codigo, :nombre, :descripcion, :tipo
    ]

    respond_to do |format|
      format.html
      format.json { render json: TramitesDeTarifasDatatable.new(
        params.merge({
          attributes_to_display: @attributes_to_display
        }),
        view_context: view_context)
      }
    end
  end

  private

    def t_tarifa_servicio_params
      params.require(:t_tarifa_servicio).permit(
        :codigo, :descripcion, :nombre,
        :clase, :precio, :estatus, :tipo, :t_tarifa_servicio_group_id
      )
    end

    def set_t_tarifa_servicio
      @t_tarifa_servicio = TTarifaServicio.find(params[:id])
    end

    def parametros_de_busqueda
      params.permit(:attribute, :search)
    end
end
