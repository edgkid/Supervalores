class TTarifaServicioGroupsController < ApplicationController  
  before_action :seleccionar_grupo, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @usar_dataTables = true
    @attributes_to_display = [:nombre, :estatus]

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

  def new
    @registro = TTarifaServicioGroup.new
  end

  def edit
  end

  def create
    @registro = TTarifaServicioGroup.new(t_tarifa_servicio_group_params)

    respond_to do |format|
      if @registro.save
        format.html { redirect_to @registro, notice: 'Grupo de servicio creado correctamente.' }
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
      if @registro.update(t_tarifa_servicio_group_params)
        format.html { redirect_to @registro, notice: 'Grupo de servicio actualizado correctamente.' }
        format.json { render :show, status: :ok, location: @registro }
      else
        @notice = @registro.errors
        format.html { render :edit }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @registro.estatus = 0
    respond_to do |format|
      if @registro.save
        format.html { redirect_to t_tarifa_servicio_groups_url, notice: 'Grupo de servicio inhabilitado correctamente.' }
        format.json { head :no_content }
      else
        @notice = @registro.errors
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def seleccionar_grupo
      @registro = TTarifaServicioGroup.find(params[:id])
    end

    def t_tarifa_servicio_group_params
      params.require(:t_tarifa_servicio_group).permit(:nombre, :estatus, :t_presupuesto_id)
    end
end
