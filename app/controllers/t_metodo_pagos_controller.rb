class TMetodoPagosController < ApplicationController
  before_action :set_t_metodo_pago, only: [:edit, :update, :destroy]

  def index
    @usar_dataTables = true
    @attributes_to_display = [:forma_pago, :descripcion, :minimo, :maximo, :estatus]

    respond_to do |format|
      format.html
      format.json { render json: ApplicationDatatable.new(
        params.merge({
          attributes_to_display: @attributes_to_display
        }),
        view_context: view_context)
      }
    end
  end

  def show
    @t_metodo_pago = TMetodoPago.find(params[:id])
    @estatus = TEstatus.find (@t_metodo_pago.estatus)
  end

  def new
    @t_metodo_pago = TMetodoPago.new
    @estatus = TEstatus.all # where( "descripcion = ? OR descripcion = ?", "Activo", "Inactivo" )
    #@estatus = TEstatus.where( "id = ? OR id = ?", 1, 2 )
  end

  def create
    @estatus = TEstatus.where( "descripcion = ? OR descripcion = ?", "Activo", "Inactivo" )
    @t_metodo_pago = TMetodoPago.new(t_metodo_pago_params)
    # @t_metodo_pago.estatus = params[:id_estatus]

    if params[:minimo] == nil || params[:maximo] != nil
      @t_metodo_pago.minimo = params[:minimo]
      @t_metodo_pago.maximo = params[:maximo]
    end

    if @t_metodo_pago.save
      redirect_to t_metodo_pagos_path, notice: 'Método de pago creado correctamente.'
    else
      @notice = @t_metodo_pago.errors
      render :action => "new"
    end
  end

  def edit
    @t_metodo_pago =TMetodoPago.find(params[:id])
    @estatus = TEstatus.all
    # @estatus = TEstatus.where( "descripcion = ? OR descripcion = ?", "Activo", "Inactivo" )
  end

  def update
    @t_metodo_pago = TMetodoPago.find(params[:id])
    @estatus = TEstatus.where( "descripcion = ? OR descripcion = ?", "Activo", "Inactivo" )

    if params[:minimo] == nil || params[:maximo] != nil
      @t_metodo_pago.minimo = params[:minimo]
      @t_metodo_pago.maximo = params[:maximo]
    end

    if @t_metodo_pago.update(t_metodo_pago_params)
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
      @t_metodo_pago = TMetodoPago.find(params[:id])
    end

end
