class TModulosController < ApplicationController
  def index
    @usar_dataTables = true
    @attributes_to_display = [:nombre, :descripcion]

    respond_to do |format|
      format.html
      format.json { render json: ApplicationDatatable.new(
        params.merge({
          attributes_to_display: @attributes_to_display,
          no_DT_RowId: true
        }),
        view_context: view_context)
      }
    end
  end
end
