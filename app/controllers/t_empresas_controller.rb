class TEmpresasController < ApplicationController
  before_action :set_t_empresa, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
		redirect_to t_facturas_path, :alert => exception.message
	end
  
  def index
    @registros = TEmpresa.all
  end

  def show
  end

  def new
    @registro = TEmpresa.new
  end

  def edit
  end

  def create
    @registro = TEmpresa.new(t_empresa_params)

    respond_to do |format|
      if @registro.save
        format.html { redirect_to @registro, notice: 'T empresa was successfully created.' }
        format.json { render :show, status: :created, location: @registro }
      else
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @registro.update(t_empresa_params)
        format.html { redirect_to @registro, notice: 'T empresa was successfully updated.' }
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
      format.html { redirect_to t_empresas_url, notice: 'T empresa was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_t_empresa
      @registro = TEmpresa.find(params[:id])
    end

    def t_empresa_params
      params.require(:t_empresa).permit(:rif, :razon_social, :tipo_valor, :sector_economico, :direccion_empresa, :fax, :web, :t_cliente_id)
    end
end
