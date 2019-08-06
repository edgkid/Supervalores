class TFacturasController < ApplicationController
  before_action :set_t_factura, only: [:edit, :update, :show, :destroy]

  def new
    @t_factura = TFactura.new
  end

  def create
    @t_factura = TFactura.new(t_factura_params)

    if @t_factura.save!
      # flash[:success] = "Factura creado exitosamente."
      redirect_to t_facturas_path
    else
      # flash.now[:danger] = "No se pudo crear el factura."
      render 'new'
    end
  end

  def edit
  end

  def update
    if @t_factura.update(t_factura_params)
      # flash[:success] = "Factura actualizado exitosamente."
      redirect_to t_facturas_path
    else
      # flash.now[:danger] = "No se pudo modificar el factura."
      render 'edit'
    end
  end

  def index
    @t_facturas = TFactura.all
  end

  def show
  end

  def destroy
    @t_factura.destroy

    # flash[:warning] = "Factura eliminado."
    redirect_to t_facturas_path
  end

  private

    def t_factura_params
      params.require(:t_factura).permit(
        :codigo, :descripcion, :nombre,
        :clase, :precio, :estatus
      )
    end

    def set_t_factura
      @t_factura = TFactura.find(params[:id])
    end
end
