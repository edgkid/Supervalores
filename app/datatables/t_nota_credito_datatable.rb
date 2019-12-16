class TNotaCreditoDatatable < ApplicationDatatable
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format

    @view_columns ||= {
      id: { source: "TNotaCredito.id" },
      t_cliente: { source: "razon_social", searchable: false },
      t_recibo: { source: "t_recibo_id", searchable: false },
      monto: { source: "monto", searchable: false },
      monto_original: { source: "monto_original", searchable: false },
      status: { source: "status", searchable: false }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        t_cliente: record.t_cliente.razon_social,
        t_recibo: record[:t_recibo_id],
        monto: record[:monto],
        monto_original: record[:monto_original],
        status: record[:status],
        DT_RowId: url_for({
          id: record.id, controller: 't_nota_creditos', action: 'show', only_path: true
        })
      }
    end
  end

  def get_raw_records
    TNotaCredito.all
  end
end
