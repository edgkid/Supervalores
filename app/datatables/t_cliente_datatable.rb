class TClienteDatatable < ApplicationDatatable
  # include TClientesHelper

  def data
    records_array = super
    records.each_with_index do |record, i|
      records_array[i].merge!({ t_estatus: record.t_estatus.descripcion })
    end
    records_array
  end

  def get_raw_records
    # list_clientes
    TCliente.all
  end
end
