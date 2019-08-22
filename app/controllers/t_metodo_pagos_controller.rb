class TMetodoPagosController < ApplicationController

  before_action :set_t_metodo_pago, only: [:edit, :update, :destroy]

  def index
    @t_metodo_pago = TMetodoPago.all
  end

  def new
    @t_metodo_pago = TMetodoPago.new
  end

  def create
    @t_metodo_pago = TMetodoPago.new(t_metodo_pago_params)

    if @t_metodo_pago.save
      redirect_to t_metodo_pagos_index_path, notice: 'Método de pago creado correctamente.'
    else
      @notice = @t_metodo_pago.errors
      render :action => "new"
    end
  end

  def edit
    @t_metodo_pago =TMetodoPago.find(params[:id])
  end

  def update
    @t_metodo_pago = TMetodoPago.find(params[:id])

    if TMetodoPago.update_attributes(t_metodo_pago_params)
      redirect_to t_metodo_pagos_index_path , notice: 'Método de pago actualizado correctamente.'
    else
      @notice = @t_metodo_pago.errors
      render :action => "edit"
    end
  end

  private
    def t_metodo_pago_params
      params.require(:t_metodo_pago).permit(:forma_pago, :descripcion, :minimo, :maximo, :estatus)
    end

    def set_t_metodo_pago
      @rol = TRol.find(params[:id])
    end

end
