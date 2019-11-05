class TEmpresaDatatable < ApplicationDatatable
  def view_columns
    super
    @view_columns.merge!({
      t_empresa_tipo_valor: { source: "TEmpresaTipoValor.descripcion" }#,
      # t_empresa_sector_economico: { source: "TEmpresaSectorEconomico.descripcion" }
    })
  end

  def data
    records_array = super
    records.each_with_index do |record, i|
      records_array[i].merge!({
        t_empresa_tipo_valor: record.t_empresa_tipo_valor.descripcion#,
        # t_empresa_sector_economico: record.t_empresa_sector_economico.descripcion
      })
    end
    records_array
  end

  def get_raw_records
    TEmpresa.joins(:t_empresa_tipo_valor)#, :t_empresa_sector_economico)
  end
end
