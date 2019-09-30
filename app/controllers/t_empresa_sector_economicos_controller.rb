class TEmpresaSectorEconomicosController < ApplicationController
  before_action :seleccionar_sector_economico, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @usar_dataTables = true
    @attributes_to_display = [:descripcion, :estatus]

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
    @registro = TEmpresaSectorEconomico.new
  end

  def edit
  end

  def create
    @registro = TEmpresaSectorEconomico.new(t_empresa_sector_economico_params)

    respond_to do |format|
      if @registro.save
        format.html { redirect_to @registro, notice: 'Sector económico creado correctamente.' }
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
      if @registro.update(t_empresa_sector_economico_params)
        format.html { redirect_to @registro, notice: 'Sector económico actualizado correctamente.' }
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
        format.html { redirect_to t_empresa_sector_economicos_url, notice: 'Sector económico inhabilitado correctamente.' }
        format.json { head :no_content }
      else
        @notice = @registro.errors
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def seleccionar_sector_economico
      @registro = TEmpresaSectorEconomico.find(params[:id])
    end

    def t_empresa_sector_economico_params
      params.require(:t_empresa_sector_economico).permit(:descripcion, :estatus)
    end
end
