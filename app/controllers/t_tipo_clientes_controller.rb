class TTipoClientesController < ApplicationController
  before_action :seleccionar_tipo_cliente, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: [:clients_index, :total_meses, :total_facturas,
    :informe]
  before_action :authorize_user_to_read_reports, only: [:informe]

  def informe
    @usar_dataTables = true
    @useDataTableFooter = true
    @do_not_use_plain_select2 = true
    @attributes_to_display = [
      :tipo_cliente, :anio_pago, :pago_enero, :pago_febrero, :pago_marzo,
      :pago_abril, :pago_mayo, :pago_junio, :pago_julio, :pago_agosto,
      :pago_septiembre, :pago_octubre, :pago_noviembre, :pago_diciembre, :total
    ]

    respond_to do |format|
      format.html
      format.json { render json: InformeTTipoClienteDatatable.new(
        params.merge({
          attributes_to_display: @attributes_to_display
        }),
        view_context: view_context)
      }
    end
  end

  def total_meses
    dataTable = InformeTTipoClienteDatatable.new(
      params.merge({
        attributes_to_display: @attributes_to_display
      }),
      view_context: view_context
    )
    raw_records = dataTable.get_raw_records
    results = {
      procesado: true,
      total_enero: view_context.number_to_balboa(raw_records.sum(:pago_enero), false),
      total_febrero: view_context.number_to_balboa(raw_records.sum(:pago_febrero), false),
      total_marzo: view_context.number_to_balboa(raw_records.sum(:pago_marzo), false),
      total_abril: view_context.number_to_balboa(raw_records.sum(:pago_abril), false),
      total_mayo: view_context.number_to_balboa(raw_records.sum(:pago_mayo), false),
      total_junio: view_context.number_to_balboa(raw_records.sum(:pago_junio), false),
      total_julio: view_context.number_to_balboa(raw_records.sum(:pago_julio), false),
      total_agosto: view_context.number_to_balboa(raw_records.sum(:pago_agosto), false),
      total_septiembre: view_context.number_to_balboa(raw_records.sum(:pago_septiembre), false),
      total_octubre: view_context.number_to_balboa(raw_records.sum(:pago_octubre), false),
      total_noviembre: view_context.number_to_balboa(raw_records.sum(:pago_noviembre), false),
      total_diciembre: view_context.number_to_balboa(raw_records.sum(:pago_diciembre), false),
      gran_total: view_context.number_to_balboa(raw_records.sum(:total), false)
    }
    render json: results
  end

  def clients_index
    @t_tipo_cliente = TTipoCliente.find(params[:id])
    @usar_dataTables = true
    @useDataTableFooter = true
    @do_not_use_plain_select2 = true
    @attributes_to_display = [
      :identificacion, :razon_social, :resolucion, :fecha_notificacion,
      :fecha_vencimiento, :recargo, :total_factura
    ]

    respond_to do |format|
      format.html
      format.json { render json: InformeTClienteDatatable.new(
        params.merge({
          attributes_to_display: @attributes_to_display,
          t_tipo_cliente_id: @t_tipo_cliente.id
        }),
        view_context: view_context)
      }
    end
  end

  def total_facturas
    @t_tipo_cliente = TTipoCliente.find(params[:t_tipo_cliente_id])
    dataTable = InformeTClienteDatatable.new(
      params.merge({
        attributes_to_display: @attributes_to_display,
        t_tipo_cliente_id: @t_tipo_cliente.id
      }),
      view_context: view_context
    )
    raw_records = dataTable.get_raw_records
    results = {
      procesado: true,
      total_recargos: view_context.number_to_balboa(raw_records.sum(:recargo), false),
      total_facturas: view_context.number_to_balboa(raw_records.sum(:total_factura), false)
    }
    render json: results
  end

  def index
    @usar_dataTables = true
    @attributes_to_display = [
      :codigo, :descripcion, :t_tipo_cliente_tipo,
      :t_periodo, :t_tarifa, :estatus
    ]

    respond_to do |format|
      format.html
      format.json { render json: TTipoClienteDatatable.new(
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
    @registro = TTipoCliente.new
  end

  def edit
  end

  def create
    @registro = TTipoCliente.new(t_tipo_cliente_params)

    respond_to do |format|
      if @registro.save
        format.html { redirect_to @registro, notice: 'Tipo de cliente creado correctamente.' }
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
      if @registro.update(t_tipo_cliente_params)
        format.html { redirect_to @registro, notice: 'Tipo de cliente actualizado correctamente.' }
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
        format.html { redirect_to t_tipo_clientes_url, notice: 'Tipo de cliente inhabilitado correctamente.' }
        format.json { head :no_content }
      else
        @notice = @registro.errors
        format.html { render :new }
        format.json { render json: @registro.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def seleccionar_tipo_cliente
      @registro = TTipoCliente.find(params[:id])
    end

    def t_tipo_cliente_params
      params.require(:t_tipo_cliente).permit(:codigo, :descripcion, :t_tipo_cliente_tipo_id, :t_periodo_id, :estatus, :t_tarifa_id)
    end

    def authorize_user_to_read_reports
      authorize! :read_reports, TTipoCliente
    end
end
