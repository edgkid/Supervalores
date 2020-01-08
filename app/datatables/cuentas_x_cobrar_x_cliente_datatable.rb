class CuentasXCobrarXClienteDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      dias_0_30: { source: "CuentasXCobrarXClienteView.dias_0_30" },
      dias_31_60: { source: "CuentasXCobrarXClienteView.dias_31_60" },
      dias_61_90: { source: "CuentasXCobrarXClienteView.dias_61_90" },
      dias_91_120: { source: "CuentasXCobrarXClienteView.dias_91_120" },
      dias_mas_de_120: { source: "CuentasXCobrarXClienteView.dias_mas_de_120" },
      total: { source: "CuentasXCobrarXClienteView.total" }
    }
  end

  def data
    records.map do |record|
      {
        dias_0_30: number_to_balboa(record.dias_0_30.truncate(2), false),
        dias_31_60: number_to_balboa(record.dias_31_60.truncate(2), false),
        dias_61_90: number_to_balboa(record.dias_61_90.truncate(2), false),
        dias_91_120: number_to_balboa(record.dias_91_120.truncate(2), false),
        dias_mas_de_120: number_to_balboa(record.dias_mas_de_120.truncate(2), false),
        total: number_to_balboa(record.total.truncate(2), false)
      }
    end
  end

  def get_raw_records
    if params[:t_resolucion_id].blank?
      # CuentasXCobrarXClienteView.all
      CuentasXCobrarXClienteView.where(t_resolucion_id: nil)
    else
      CuentasXCobrarXClienteView.where(t_resolucion_id: params[:t_resolucion_id])
    end
  end
end
