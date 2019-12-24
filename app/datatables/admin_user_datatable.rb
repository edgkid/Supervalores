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
        DT_RowId: url_for(
          # TFactura.find(record.t_factura_id), TRecibo.find(record.id))
          TRecibo.find(record.id).t_factura.try(:t_resolucion).try(:t_cliente) ||
          TRecibo.find(record.id).t_factura.t_cliente
        )
      }
    end
  end

  def get_raw_records
    User.all
  end
end
