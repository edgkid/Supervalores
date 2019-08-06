class TResolucionsController < ApplicationController
  before_action :set_t_resolucion, only: [:show, :edit, :update, :destroy]

  def index
    @registro = TResolucion.all
  end

  def show
  end

  def new
    @registro = TResolucion.new
  end

  def edit
  end

  def create
    @registro = TResolucion.new(t_resolucion_params)

    respond_to do |format|
      if @registro.save
        format.html { redirect_to @registro, notice: 'T resolucion was successfully created.' }
        format.json { render :show, status: :created, location: @registro }
      else
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @registro.update(t_resolucion_params)
        format.html { redirect_to @registro, notice: 'T resolucion was successfully updated.' }
        format.json { render :show, status: :ok, location: @registro }
      else
        format.html { render :edit }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @registro.destroy
    respond_to do |format|
      format.html { redirect_to t_resolucions_url, notice: 'T resolucion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_t_resolucion
      @registro = TResolucion.find(params[:id])
    end

    def t_resolucion_params
      params.require(:t_resolucion).permit(:descripcion, :fecha_resolucion, :t_cliente_id)
    end
end
