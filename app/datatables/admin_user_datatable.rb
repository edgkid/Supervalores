class AdminUserDatatable < ApplicationDatatable
  def data
    records_list = []
    records = User.all
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
      records_list.last.merge!({DT_RowId: url_for([:admin, record])})
    end
    records_list
  end

  def get_raw_records
    User.all
  end
end
