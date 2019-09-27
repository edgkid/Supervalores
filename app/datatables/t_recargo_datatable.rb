class TRecargoDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
      descripcion: { source: "TRecargo.descripcion" },
      tasa: { source: "TRecargo.tasa" },
      t_periodo: { source: "TPeriodo.descripcion" },
      estatus: { source: "TRecargo.estatus" },
    }
  end

  def data
    records.map do |record|
      {
        # example:
        # id: record.id,
        # name: record.name
        descripcion: record.descripcion,
        tasa: record.tasa,
        periodo: record.t_periodo.descripcion,
        estatus: estatus_text(record.estatus)
      }
    end
  end

  def get_raw_records
    # insert query here
    # User.all
    TRecargo.all
  end

  private

    def estatus_text estatus
      estatus == 0 ? "Inactivo" : "Disponible"
    end
end
