class TConfFacAutomaticaDatatable < ApplicationDatatable
  def view_columns
    super
    @view_columns.merge!({
      t_periodo: { source: "TPeriodo.descripcion" },
      t_tipo_cliente: { source: "TTipoCliente.descripcion" }
    })
  end

  def data
    records_array = super
    records.each_with_index do |record, i|
      records_array[i].merge!({
        t_periodo: record.t_periodo.descripcion,
        t_tipo_cliente: record.t_tipo_cliente.descripcion
      })
    end
    records_array
  end

  def get_raw_records
    TConfFacAutomatica.joins(:t_periodo, :t_tipo_cliente)
  end
end
