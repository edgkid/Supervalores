class TEmpresasController < ApplicationController
  before_action :seleccionar_empresa, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @usar_dataTables = true
    @attributes_to_display = [
      :rif, :razon_social, :t_empresa_tipo_valor,
      :t_empresa_sector_economico, :telefono, :email
    ]

    respond_to do |format|
      format.html
      format.json { render json: TEmpresaDatatable.new(
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
    @registro = TEmpresa.new
  end

  def edit
  end

  def create
    @registro = TEmpresa.new(t_empresa_params)

    respond_to do |format|
      if @registro.save
        format.html { redirect_to @registro, notice: 'Empresa creada correctamente.' }
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
      if @registro.update(t_empresa_params)
        format.html { redirect_to @registro, notice: 'Empresa actualizada correctamente.' }
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
        format.html { redirect_to t_empresas_url, notice: 'Empresa inhabilitada correctamente.' }
        format.json { head :no_content }
      else
        @notice = @registro.errors
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def seleccionar_empresa
      @registro = TEmpresa.find(params[:id])
    end

    def t_empresa_params
      params.require(:t_empresa).permit(:rif, :dv, :razon_social, :t_empresa_tipo_valor_id, :t_empresa_sector_economico_id, :direccion_empresa, :fax, :web, :telefono, :email)
    end
end
