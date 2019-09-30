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
      columns[column[:data].to_sym] = {
        source: "#{params[:controller].singularize.camelize}.#{column[:data]}"
      }
    end
    @view_columns = columns
  end

  def data
    records_list = []
    records.each do |record|
      records_list << {}
      params[:attributes_to_display].each do |attribute|
        if attribute == :estatus
          records_list.last.merge!({ "#{attribute}": estatus_text(record.send(attribute)) })
        else
          records_list.last.merge!({ "#{attribute}": record.send(attribute) })
        end
      end
      unless params[:no_DT_RowId] == true
        records_list.last.merge!({
          DT_RowId: url_with_or_without_parent_resource_for(
            record.try(params[:parent_resource] || ''), record)
        })
      end
    end
    records_list
  end

  def get_raw_records
    params[:controller].singularize.camelize.constantize.all
  end

  protected
    def url_with_or_without_parent_resource_for(parent_resource, resource)
      if parent_resource then url_for([parent_resource, resource]) else url_for(resource) end
    end

    def estatus_text estatus
      estatus == 0 ? "Inactivo" : "Disponible"
    end
end
