class TTipoClienteDatatable < ApplicationDatatable
  def view_columns
    super
    @view_columns.merge!({
      t_tipo_cliente_tipo: { source: "TTipoClienteTipo.descripcion" },
      t_tarifa: { source: "TTarifa.nombre" }
    })
  end

  def data
    records_array = super
    records.each_with_index do |record, i|
      records_array[i].merge!({
        t_tipo_cliente_tipo: record.t_tipo_cliente_tipo.descripcion,
        t_tarifa: record.t_tarifa.nombre
      })
    end
    records_array
  end
end
