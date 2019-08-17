# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
connection = ActiveRecord::Base.connection()

connection.execute(" DELETE FROM t_users_rols; commit;")
connection.execute(" DELETE FROM permisions; commit;")
connection.execute(" DELETE FROM users; commit;")

connection.execute(" DELETE FROM t_rols_elementos; commit;")
connection.execute(" DELETE FROM elementos; commit;")
connection.execute(" DELETE FROM t_rols; commit;")

email = 'admin@cxc.com'
pass = '2019AdminCxC'

user = User.find_by(email: email)
if user == nil
  user = User.new
  user.nombre = "CXC"
  user.apellido = "Administrador"
  user.email = email
  user.password = pass
  user.password_confirmation = pass
  user.role = "AdminCxC"
  user.estado = true
  user.save!
end

email = 'SuperAdmin@cxc.com'
pass = 'Sudo123'

user = User.find_by(email: email)
if user == nil
  user = User.new
  user.nombre = "SuperCXC"
  user.apellido = "Administrador"
  user.email = email
  user.password = pass
  user.password_confirmation = pass
  user.role = "SuperAdmin"
  user.estado = true
  user.save!
end

TRol.create(direccion_url: nil, li_class: nil, i_class: nil, u_class: nil, nombre: "SuperAdmin", descripcion:"Rol de usuario con acceso a todos los módulos del sistema", peso:1, estatus: 1, icon_class:nil)
TRol.create(direccion_url: nil, li_class: nil, i_class: nil, u_class: nil, nombre: "AdminCxC", descripcion:"Rol de usuario con acceso a todos los módulos del sistema. No gestiona usuarios", peso:1, estatus: 1, icon_class:nil)

Elemento.create(nombre: "Consultar Módulos del Sistema", modelo:"Elemento")
Elemento.create(nombre: "Gestionar Permisos del Sistema", modelo:"Permission")
Elemento.create(nombre: "Gestionar Caja", modelo:"TCaja")
Elemento.create(nombre: "Gestionar Sub-Catálogos de Cuentas", modelo:"TCatalogoCuentaSub")
Elemento.create(nombre: "Gestionar Catálogos de Cuenta", modelo:"TCatalogoCuentum")
Elemento.create(nombre: "Gestionar Tarifas de Clientes ", modelo:"TClienteTarifa")
Elemento.create(nombre: "Gestionar Clientes", modelo:"TCliente")
Elemento.create(nombre: "Gestionar Tarifas", modelo:"TClienteTarifa")
Elemento.create(nombre: "Gestionar Cuentas Financieras", modelo:"TCuentaFinanciera")
Elemento.create(nombre: "Gestionar Cuentas de Venta ", modelo:"TCuentaVentum")
Elemento.create(nombre: "Administración de Correos Masivos ", modelo:"TEmailMasivo")
Elemento.create(nombre: "Gestion de Emisiones ", modelo:"TEmision")
Elemento.create(nombre: "Gestion de Empresas", modelo:"TEmpresa")
Elemento.create(nombre: "Gestionar Estados de Cuenta (Contabilidad)", modelo:"TEstadoCuentaCont")
Elemento.create(nombre: "Gestionar Estados de Cuenta", modelo:"TEstadoCuentum")
Elemento.create(nombre: "Gestionar Estatus", modelo:"TEstatus")
Elemento.create(nombre: "Gestionar Detalles de Factura ", modelo:"TFacturaDetalle")
Elemento.create(nombre: "Gestionar Facturas", modelo:"TFactura")
Elemento.create(nombre: "Gestionar Leyendas de Facturas", modelo:"TLeyenda")
Elemento.create(nombre: "Gestionar Métodos de Pago", modelo:"TMetodoPago")
Elemento.create(nombre: "Gestionar Notas de Crédito", modelo:"TNotaCredito")
Elemento.create(nombre: "Gestionar Periodos", modelo:"TPeriodo")
Elemento.create(nombre: "Gestionar Personas", modelo:"TPersona ")
Elemento.create(nombre: "Gestionar Presupuestos", modelo:"TPresupuesto")
Elemento.create(nombre: "Gestionar Recargos a Clientes", modelo:"TRecargoXCliente")
Elemento.create(nombre: "Gestionar Recargos", modelo:"TRecargo")
Elemento.create(nombre: "Gestionar Recibos", modelo:"TRecibo")
Elemento.create(nombre: "Gestionar Información de Resolución de Clientes", modelo:"TResolucion")
Elemento.create(nombre: "Gestionar Roles de Usuarios", modelo:"TRol")
Elemento.create(nombre: "Gestionar Conjuntos de Tarifas de Servicios", modelo:"TTarifaServicioGroup")
Elemento.create(nombre: "Gestionar tarifas de Servicios", modelo:"TTarifaServicio")
Elemento.create(nombre: "Gestionar Tarifas", modelo:"TTarifa")
Elemento.create(nombre: "Gestionar Tipo de Clientes", modelo:"TTipoCliente")
Elemento.create(nombre: "Gestionar Tipo de Cuentas", modelo:"TTipoCuenta")
Elemento.create(nombre: "Gestionar Tipo de Emisiones", modelo:"TTipoEmision")
Elemento.create(nombre: "Gestionar Tipo de Personas", modelo:"TTipoPersona")
Elemento.create(nombre: "Gestionar Usuarios", modelo:"User")

#Rol por usuario
connection.execute(" INSERT INTO t_users_rols VALUES (2,1); commit;")
connection.execute(" INSERT INTO t_users_rols VALUES (1,2); commit;")
