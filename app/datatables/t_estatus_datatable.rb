class TEstatusDatatable < ApplicationDatatable
  include TEstatusesHelper

  def data
    records_array = super
    records.each_with_index do |record, i|
      records_array[i].merge!({
        para: para_text(record.para),        
      })
    end
    records_array
  end

  def get_raw_records
    records = TEstatus.all
  end
end
