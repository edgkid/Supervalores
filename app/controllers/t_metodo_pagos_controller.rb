class TMetodoPagosController < ApplicationController

  before_action :set_t_metodo_pago, only: [:edit, :update, :destroy]

  def index
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  private
    def t_metodo_pago_params
      params.require(:t_metodo_pago).permit(:forma_pago, :descripcion, :minimo, :maximo, :estatus)
    end

    def set_t_metodo_pago
      @rol = TRol.find(params[:id])
    end

end
