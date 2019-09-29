class TTipoEmisionsController < ApplicationController
  before_action :seleccionar_tipo_emision, only: [:show, :edit, :update, :destroy]
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
    @registro = TTipoEmision.new
  end

  def edit
  end

  def create
    @registro = TTipoEmision.new(t_tipo_emision_params)

    respond_to do |format|
      if @registro.save
        format.html { redirect_to @registro, notice: 'Tipo de emision creado correctamente.' }
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
      if @registro.update(t_tipo_emision_params)
        format.html { redirect_to @registro, notice: 'Tipo de emision actualizado correctamente.' }
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
        format.html { redirect_to t_tipo_emisions_url, notice: 'Tipo de emision inhabilitado correctamente.' }
        format.json { head :no_content }
      else
        @notice = @registro.errors
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def seleccionar_tipo_emision
      @registro = TTipoEmision.find(params[:id])
    end

    def t_tipo_emision_params
      params.require(:t_tipo_emision).permit(:descripcion, :estatus)
    end
end
