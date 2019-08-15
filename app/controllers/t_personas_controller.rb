class TPersonasController < ApplicationController
  before_action :set_t_persona, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
		redirect_to dashboard_access_denied_path, :alert => exception.message
	end

  def index
    @registros = TPersona.all
  end

  def show
  end

  def new
    @registro = TPersona.new
  end

  def edit
  end

  def create
    @registro = TPersona.new(t_persona_params)

    respond_to do |format|
      if @registro.save
        format.html { redirect_to @registro, notice: 'T persona was successfully created.' }
        format.json { render :show, status: :created, location: @registro }
      else
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @registro.update(t_persona_params)
        format.html { redirect_to @registro, notice: 'T persona was successfully updated.' }
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
      format.html { redirect_to t_personas_url, notice: 'T persona was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_t_persona
      @registro = TPersona.find(params[:id])
    end

    def t_persona_params
      params.require(:t_persona).permit(:cedula, :nombre, :apellido, :num_licencia, :t_cliente_id, :t_empresa_id, :cargo)
    end
end
