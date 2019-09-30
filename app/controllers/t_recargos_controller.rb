class TRecargosController < ApplicationController
  respond_to :json, only: :find_by_descripcion
  before_action :seleccionar_recargo, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @usar_dataTables = true
    @attributes_to_display = [:descripcion, :tasa, :t_periodo, :estatus]

    respond_to do |format|
      format.html
      format.json { render json: TRecargoDatatable.new(
        params.merge({ attributes_to_display: @attributes_to_display }),
        view_context: view_context)
      }
    end
  end

  def show
  end

  def new
    @registro = TRecargo.new
  end

  def edit
  end

  def create
    @registro = TRecargo.new(t_recargo_params)
    respond_to do |format|
      if @registro.save
        format.html { redirect_to @registro, notice: 'Recargo creado correctamente.' }
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
      if @registro.update(t_recargo_params)
        format.html { redirect_to @registro, notice: 'Recargo actualizado correctamente.' }
        format.json { render :show, status: :ok, location: @registro }
      else
        @notice = @registro.errors
        format.html { render :edit }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @registro.destroy
    redirect_to t_recargos_path, notice: 'Recargo eliminado correctamente'
  end

  def find_by_descripcion
    search = search_params[:search]
    respond_with TRecargo.where('descripcion LIKE ?', "%#{search}%").first(10)
  end

  private
    def seleccionar_recargo
      @registro = TRecargo.find(params[:id])
    end

    def t_recargo_params
      params.require(:t_recargo).permit(:descripcion, :tasa, :estatus, :t_periodo_id, :factura_id)
    end

    def search_params
      params.permit(:search)
    end
end
