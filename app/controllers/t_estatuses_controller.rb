class TEstatusesController < ApplicationController
  before_action :set_t_estatus, only: [:show, :edit, :update, :destroy]

  def index
    @registros = TEstatus.all
  end

  def show
  end

  def new
    @registro = TEstatus.new
  end

  def edit
  end

  def create
    @registro = TEstatus.new(t_estatus_params)

    respond_to do |format|
      if @registro.save
        format.html { redirect_to @registro, notice: 'T estatus was successfully created.' }
        format.json { render :show, status: :created, location: @registro }
      else
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @registro.update(t_estatus_params)
        format.html { redirect_to @registro, notice: 'T estatus was successfully updated.' }
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
      format.html { redirect_to t_estatuses_url, notice: 'T estatus was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_t_estatus
      @registro = TEstatus.find(params[:id])
    end

    def t_estatus_params
      params.require(:t_estatus).permit(:estatus, :para, :descripcion, :color)
    end
end
