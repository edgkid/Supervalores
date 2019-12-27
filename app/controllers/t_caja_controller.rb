class TCajaController < ApplicationController
  def index
    @usar_dataTables = true
    @useDataTableFooter = true
    @do_not_use_plain_select2 = true
    @no_cache = true

    @attributes_to_display = [
      :id, :t_cliente, :t_resolucion, :fecha_pago,
      :pago_pendiente, :pago_recibido, :user#, :vuelto
    ]
    
    respond_to do |format|
      format.html
      format.json { render json: TCajaDatatable.new(
        params.merge({
          attributes_to_display: @attributes_to_display,
          from: params[:from],
          to: params[:to]
        }),
        view_context: view_context)
      }
    end
  end

  def get_total
    dataTable =  TCajaDatatable.new(
      params.merge({
        attributes_to_display: @attributes_to_display,
        from: params[:from],
        to: params[:to]
      })
    )
    total = dataTable.get_raw_records.sum("COALESCE(t_recibos.pago_pendiente, 0)")
    pagado = dataTable.get_raw_records.sum("COALESCE(t_recibos.pago_recibido, 0)")
    results = {
      procesado: true,
      total: view_context.number_to_balboa(total, false),
      pagado: view_context.number_to_balboa(pagado, false)
    }
    render json: results
  end
end
