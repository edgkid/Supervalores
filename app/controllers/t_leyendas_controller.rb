class TLeyendasController < ApplicationController
  before_action :set_t_leyenda, only: [:edit, :update, :show, :destroy]

  load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
		redirect_to t_facturas_path, :alert => exception.message
	end
  
  def new
    @t_leyenda = TLeyenda.new
  end

  def create
    @t_leyenda = TLeyenda.new(t_leyenda_params)

    if @t_leyenda.save
      # flash[:success] = "Leyenda creada exitosamente."
      redirect_to t_leyendas_path
    else
      # flash.now[:danger] = "No se pudo crear la leyenda."
      render 'new'
    end
  end

  def edit
  end

  def update
    if @t_leyenda.update(t_leyenda_params)
      # flash[:success] = "Leyenda actualizada exitosamente."
      redirect_to t_leyendas_path
    else
      # flash.now[:danger] = "No se pudo modificar la leyenda."
      render 'edit'
    end
  end

  def index
    @usar_dataTables = true
    @t_leyendas = TLeyenda.all
  end

  def show
  end

  def destroy
    @t_leyenda.destroy

    # flash[:warning] = "Leyenda eliminada."
    redirect_to t_leyendas_path
  end

  private

    def t_leyenda_params
      params.require(:t_leyenda).permit(:anio, :descripcion, :estatus)
    end

    def set_t_leyenda
      @t_leyenda = TLeyenda.find(params[:id])
    end
end
