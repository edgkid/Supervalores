class TTipoPersonasController < ApplicationController
  before_action :set_t_tipo_persona, only: [:show, :edit, :update, :destroy]

  def index
    @registros = TTipoPersona.all
  end

  def show
  end

  def new
    @registro = TTipoPersona.new
  end

  def edit
  end

  def create
    @registro = TTipoPersona.new(t_tipo_persona_params)

    respond_to do |format|
      if @registro.save
        format.html { redirect_to @registro, notice: 'T tipo persona was successfully created.' }
        format.json { render :show, status: :created, location: @registro }
      else
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @registro.update(t_tipo_persona_params)
        format.html { redirect_to @registro, notice: 'T tipo persona was successfully updated.' }
        format.json { render :show, status: :ok, location: @registro }
      else
        format.html { render :edit }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @registro.estatus = 0
    @registro.save

    respond_to do |format|
      format.html { redirect_to t_tipo_personas_url, notice: 'T tipo persona was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private    
    def set_t_tipo_persona
      @registro = TTipoPersona.find(params[:id])
    end
    
    def t_tipo_persona_params
      params.require(:t_tipo_persona).permit(:descripcion, :estatus)
    end
end
