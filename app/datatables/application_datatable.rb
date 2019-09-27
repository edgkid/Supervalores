class ApplicationDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable
  def_delegator :@view, :url_for

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    columns = {}
    params[:columns].each do |_, column|
      if column[:data] == 'periodo'
        columns[:t_periodo] = { source: "TPeriodo.descripcion" }
      else
        columns[column[:data].to_sym] = {
          source: "#{params[:controller].singularize.camelize}.#{column[:data]}"
        }
      end
    end
    @view_columns = columns
  end

  def data
    records_list = []
    records.each do |record|
      records_list << {}
      params[:attributes_to_display].each do |attribute|
        if attribute == :periodo
          records_list.last.merge!({ "#{attribute}": record.t_periodo.descripcion })
        elsif attribute == :estatus
          records_list.last.merge!({ "#{attribute}": estatus_text(record.send(attribute)) })
        else
          records_list.last.merge!({ "#{attribute}": record.send(attribute) })
        end
      end
      records_list.last.merge!({ DT_RowId: url_for(record) })
    end
    records_list
  end

  def get_raw_records
    params[:controller].singularize.camelize.constantize.all
  end

  private

    def estatus_text estatus
      estatus == 0 ? "Inactivo" : "Disponible"
    end
end
