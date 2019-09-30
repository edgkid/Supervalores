class TRecargoDatatable < ApplicationDatatable
  def view_columns
    super
    @view_columns.merge!({
      t_periodo: { source: "TPeriodo.descripcion" }
    })
  end

  def data
    records_array = super
    records.each_with_index do |record, i|
      records_array[i].merge!({ t_periodo: record.t_periodo.descripcion })
    end
    records_array
  end

  def get_raw_records
    TRecargo.joins(:t_periodo)
  end
end
