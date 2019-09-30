class TTipoClienteDatatable < ApplicationDatatable
  def view_columns
    super
    @view_columns.merge!({
      t_tipo_cliente_tipo: { source: "TTipoClienteTipo.descripcion" },
      t_periodo: { source: "TPeriodo.descripcion" },
      t_tarifa: { source: "TTarifa.nombre" }
    })
  end

  def data
    records_array = super
    records.each_with_index do |record, i|
      records_array[i].merge!({
        t_tipo_cliente_tipo: record.t_tipo_cliente_tipo.descripcion,
        t_periodo: record.t_periodo.descripcion,
        t_tarifa: record.t_tarifa.nombre
      })
    end
    records_array
  end

  def get_raw_records
    TTipoCliente.joins(:t_tipo_cliente_tipo, :t_periodo, :t_tarifa)
  end
end
