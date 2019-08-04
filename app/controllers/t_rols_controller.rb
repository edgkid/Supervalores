class TRolsController < ApplicationController

  before_action :set_t_rol, only: [:edit, :update, :destroy]

  def index
    @rols = TRol.all
  end

  def create
  end

  def new
  end

  def edit
  end

  def update
  end

  def delete
  end

  def destroy
  end

  private
    def t_rols_params
      params.require(:rol).permit(:direccion_url, :li_class, :i_class, :u_class, :nombre, :descripcion, :peso, :estatus, :icon_class)
    end

    def set_t_rol
      @rol = TRol.find(params[:id])
    end

end
