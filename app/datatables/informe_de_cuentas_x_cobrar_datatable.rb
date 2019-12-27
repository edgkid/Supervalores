class InformeDeCuentasXCobrarDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      descripcion: { source: "InformeDeCuentasXCobrarView.descripcion" },
      cantidad_clientes: { source: "InformeDeCuentasXCobrarView.cantidad_clientes" },
      cantidad_facturas: { source: "InformeDeCuentasXCobrarView.cantidad_facturas" },
      dias_0_30: { source: "InformeDeCuentasXCobrarView.dias_0_30" },
      dias_31_60: { source: "InformeDeCuentasXCobrarView.dias_31_60" },
      dias_61_90: { source: "InformeDeCuentasXCobrarView.dias_61_90" },
      dias_91_120: { source: "InformeDeCuentasXCobrarView.dias_91_120" },
      dias_mas_de_120: { source: "InformeDeCuentasXCobrarView.dias_mas_de_120"},
      total: { source: "InformeDeCuentasXCobrarView.total" }
    }
  end

  def data
    records.map do |record|
      {
        descripcion: record.descripcion,
        cantidad_clientes: record.cantidad_clientes,
        cantidad_facturas: record.cantidad_facturas,
        dias_0_30: number_to_balboa(record.dias_0_30.truncate(2), false),
        dias_31_60: number_to_balboa(record.dias_31_60.truncate(2), false),
        dias_61_90: number_to_balboa(record.dias_61_90.truncate(2), false),
        dias_91_120: number_to_balboa(record.dias_91_120.truncate(2), false),
        dias_mas_de_120: number_to_balboa(record.dias_mas_de_120.truncate(2), false),
        total: number_to_balboa(record.total.truncate(2), false),
        DT_RowId: url_for({
          id: record.id, controller: 't_tipo_clientes', action: 'clients_index', only_path: true
        })
        #DT_RowId: url_for(TTipoCliente.find(record.id))
      }
    end
  end

  def get_raw_records
    InformeDeCuentasXCobrarView.all
  end
end
