class AdminUserDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      nombre: { source: "User.nombre" },
      apellido: { source: "User.apellido" },
      email: { source: "User.email" },
      last_sign_in_at: { source: "User.last_sign_in_at" },
      estatus: { source: "User.estatus" }
    }
  end

  def data
    records.map do |record|
      {
        nombre: record.nombre,
        apellido: record.apellido,
        email: record.email,
        last_sign_in_at: record.last_sign_in_at,
        estatus: record.estatus,
        DT_RowId: url_with_or_without_parent_resource_for(
          record.try(params[:parent_resource] || ''), [:admin, record]
        )
      }
    end
  end

  def get_raw_records
    User.all
  end
end
