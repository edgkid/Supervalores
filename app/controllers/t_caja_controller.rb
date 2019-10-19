class TCajaController < ApplicationController
  def index
    @usar_dataTables = true
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
          attributes_to_display: @attributes_to_display
        }),
        view_context: view_context)
      }
    end
  end
end
