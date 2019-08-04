class TRolsController < ApplicationController

  before_action :set_t_rol, only: [:edit, :update, :destroy]

  def index
    @rols = TRol.all
  end

  def show
    @rol =TRol.find(params[:id])
  end

  def new
    @rol=TRol.new
  end

  def create
    @rol = TRol.new(t_rols_params)
    @rol.save
    redirect_to(:action => 'index')
  end

  def edit
    @rol =TRol.find(params[:id])
  end

  def update
    @rol = TRol.find(params[:id])
    @rol.update_attributes(t_rols_params)

    redirect_to(:action => 'index')
  end

  def destroy
    @rol = TRol.find(params[:id])
    @rol.delete
    redirect_to(:action => 'index')
  end

  private
    def t_rols_params
      params.require(:rol).permit(:direccion_url, :li_class, :i_class, :u_class, :nombre, :descripcion, :peso, :estatus, :icon_class)
    end

    def set_t_rol
      @rol = TRol.find(params[:id])
    end

end
