class TReciboDatatable < ApplicationDatatable

  def view_columns
    super
    @view_columns.merge!({
      t_metodo_pago: { source: "TMetodoPago.forma_pago" }
    })
  end

  def data
    records_array = super
    records.each_with_index do |record, i|
      records_array[i].merge!({ t_metodo_pago: record.t_metodo_pago.forma_pago })
    end
    records_array
  end

end
