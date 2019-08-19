# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
connection = ActiveRecord::Base.connection()
connection.execute(" DELETE FROM t_elementos_x_rols; commit;")
connection.execute(" DELETE FROM t_elementos; commit;")
connection.execute(" DELETE FROM t_users_rols; commit;")
connection.execute(" DELETE FROM permissions; commit;")
connection.execute(" DELETE FROM users; commit;")
connection.execute(" DELETE FROM t_rols; commit;")

email = 'adminSMV@cxc.com'
pass = '2019AdminCxC'

user = User.find_by(email: email)
if user == nil
  user = User.new
  user.nombre = "CXC"
  user.apellido = "Administrador"
  user.email = email
  user.password = pass
  user.password_confirmation = pass
  user.role = "SuperAdmin"
  user.estado = true
  user.save!
end
print "Usuario commun #{email} - #{pass}\n"

TRol.create(direccion_url: nil, li_class: nil, i_class: nil, u_class: nil, nombre: "SuperAdmin", descripcion:"Rol de usuario con acceso a todos los módulos del sistema", peso:1, estatus: 1, icon_class:nil)
TRol.create(direccion_url: nil, li_class: nil, i_class: nil, u_class: nil, nombre: "AdminCxC", descripcion:"Rol de usuario con acceso a todos los módulos del sistema. No gestiona usuarios", peso:1, estatus: 1, icon_class:nil)

TElemento.create(nombre: "Consultar Módulos del Sistema", modelo:"Elemento")
TElemento.create(nombre: "Gestionar Permisos del Sistema", modelo:"Permission")
TElemento.create(nombre: "Gestionar Sub-Catálogos de Cuentas", modelo:"TCatalogoCuentaSub")
TElemento.create(nombre: "Gestionar Catálogos de Cuenta", modelo:"TCatalogoCuentum")
TElemento.create(nombre: "Gestionar Tarifas de Clientes ", modelo:"TClienteTarifa")
TElemento.create(nombre: "Gestionar Clientes", modelo:"TCliente")
TElemento.create(nombre: "Gestionar Tarifas", modelo:"TClienteTarifa")
TElemento.create(nombre: "Gestionar Cuentas Financieras", modelo:"TCuentaFinanciera")
TElemento.create(nombre: "Gestionar Cuentas de Venta ", modelo:"TCuentaVentum")
TElemento.create(nombre: "Administración de Correos Masivos ", modelo:"TEmailMasivo")
TElemento.create(nombre: "Gestion de Emisiones ", modelo:"TEmision")
TElemento.create(nombre: "Gestion de Empresas", modelo:"TEmpresa")
TElemento.create(nombre: "Gestionar Estados de Cuenta (Contabilidad)", modelo:"TEstadoCuentaCont")
TElemento.create(nombre: "Gestionar Estados de Cuenta", modelo:"TEstadoCuentum")
TElemento.create(nombre: "Gestionar Estatus", modelo:"TEstatus")
TElemento.create(nombre: "Gestionar Detalles de Factura ", modelo:"TFacturaDetalle")
TElemento.create(nombre: "Gestionar Facturas", modelo:"TFactura")
TElemento.create(nombre: "Gestionar Leyendas de Facturas", modelo:"TLeyenda")
TElemento.create(nombre: "Gestionar Métodos de Pago", modelo:"TMetodoPago")
TElemento.create(nombre: "Gestionar Notas de Crédito", modelo:"TNotaCredito")
TElemento.create(nombre: "Gestionar Periodos", modelo:"TPeriodo")
TElemento.create(nombre: "Gestionar Personas", modelo:"TPersona ")
TElemento.create(nombre: "Gestionar Presupuestos", modelo:"TPresupuesto")
TElemento.create(nombre: "Gestionar Recargos a Clientes", modelo:"TRecargoXCliente")
TElemento.create(nombre: "Gestionar Recargos", modelo:"TRecargo")
TElemento.create(nombre: "Gestionar Recibos", modelo:"TRecibo")
TElemento.create(nombre: "Gestionar Información de Resolución de Clientes", modelo:"TResolucion")
TElemento.create(nombre: "Gestionar Roles de Usuarios", modelo:"TRol")
TElemento.create(nombre: "Gestionar Conjuntos de Tarifas de Servicios", modelo:"TTarifaServicioGroup")
TElemento.create(nombre: "Gestionar tarifas de Servicios", modelo:"TTarifaServicio")
TElemento.create(nombre: "Gestionar Tarifas", modelo:"TTarifa")
TElemento.create(nombre: "Gestionar Tipo de Clientes", modelo:"TTipoCliente")
TElemento.create(nombre: "Gestionar Tipo de Cuentas", modelo:"TTipoCuenta")
TElemento.create(nombre: "Gestionar Tipo de Emisiones", modelo:"TTipoEmision")
TElemento.create(nombre: "Gestionar Tipo de Personas", modelo:"TTipoPersona")
TElemento.create(nombre: "Gestionar Usuarios", modelo:"User")

connection.execute(" Update users SET role = 'SuperAdmin', estado = 'true' WHERE email = 'admin@cxc.com' AND nombre = 'CXC' AND apellido = 'Administrador'; commit;")

# Requisitos de migracion
#  sudo -u postgres psql -U postgres -c 'CREATE DATABASE cxc';
#  sudo -u postgres psql -U postgres cxc < data/cxc_db_export.pgsql
continue = true

check_previous_migration = connection.execute("SELECT * FROM schema_migrations sm WHERE sm.version = '0'")
if check_previous_migration.count > 0
  print "La migracion solo se hace una vez ;).\n"
else
  begin
    if continue
      connection.execute("CREATE USER migracion WITH PASSWORD 'cxc_migracion'")
    end
  rescue Exception => error
    if !error.inspect.include? "already exists"
      print "Problema =(: #{error.inspect}\n"
      continue = false
    end
  end

  begin
    if continue
      connection.execute("GRANT USAGE ON SCHEMA public TO migracion")
      connection.execute("GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO migracion")
      connection.execute("GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO migracion")
      connection.execute("GRANT ALL PRIVILEGES ON DATABASE cxc to migracion")
      connection.execute("ALTER USER migracion WITH SUPERUSER")
    end
  rescue Exception => error
    if error.inspect.include? 'database "cxc" does not exist'
      print "Problema =(: No se puede migrar sin la base de datos origen (cxc). Debes crear la base de datos cxc e importarle el archivo cxc_db_export.sql ubicado en la carpeta data dentro del proyecto.\n"
      continue = false
    elsif error.inspect.include? 'role "migracion" does not exist'
      print "Problema =(: Se intento crear el usuario(migracion) pero parece que no se tienen permisos.\n"
      continue = false
    end
  end

  begin
    if continue
      connection.execute("GRANT ALL PRIVILEGES ON DATABASE cxc to postgres")
    end
  rescue Exception => error
    if error.inspect.include? 'database "cxc" does not exist'
      print "Problema =(: No se puede migrar sin la base de datos origen (cxc). Debes crear la base de datos cxc e importarle el archivo cxc_db_export.sql ubicado en la carpeta data dentro del proyecto.\n"
      continue = false
    end
  end

  begin
    if continue
      connection.execute("GRANT ALL PRIVILEGES ON DATABASE supervalores_development to migracion")
    end
  rescue Exception => error
    if error.inspect.include? 'database "supervalores_development" does not exist'
      print "Problema =(: No se puede migrar sin la base de datos destino (supervalores_development).\n"
      continue = false
    elsif error.inspect.include? 'role "migracion" does not exist'
      print "Problema =(: Se intento crear el usuario(migracion) pero parece que no se tienen permisos.\n"
      continue = false
    end
  end

  begin
    if continue
      connection.execute("CREATE EXTENSION dblink")
    end
  rescue Exception => error
    if !error.inspect.include?  'extension "dblink" already exists'
      print "Problema =(: #{error.inspect}\n"
      continue = false
    end
  end

  begin
    if continue
      connection.execute("CREATE FOREIGN DATA WRAPPER cxc_db VALIDATOR postgresql_fdw_validator")
    end
  rescue Exception => error
    if !error.inspect.include?  'wrapper "cxc_db" already exists'
      print "Problema =(: #{error.inspect}\n"
      continue = false
    end
  end

  begin
    if continue
      connection.execute("CREATE SERVER cxc_server FOREIGN DATA WRAPPER cxc_db OPTIONS (hostaddr '127.0.0.1', dbname 'cxc')")
    end
  rescue Exception => error
    if !error.inspect.include?  'server "cxc_server" already exists'
      print "Problema =(: #{error.inspect}\n"
      continue = false
    end
  end

  #Colocar usuario de base de datos con su contraseña
  begin
    if continue
      connection.execute("CREATE USER MAPPING FOR postgres SERVER cxc_server OPTIONS (user 'migracion', password 'cxc_migracion')")
    end
  rescue Exception => error
    if !error.inspect.include?  'mapping for "postgres" already exists for server cxc_server'
      print "Problema =(: #{error.inspect}\n"
      continue = false
    end
  end

  begin
    if continue
      connection.execute("GRANT USAGE ON FOREIGN SERVER cxc_server TO postgres")
    end
  rescue Exception => error
    if error.inspect.include? 'database "supervalores_development" does not exist'
      print "Problema =(: No se puede migrar sin la base de datos destino (supervalores_development).\n"
      continue = false
    end
  end

  if continue
    check_dblink = connection.execute("SELECT pg_namespace.nspname, pg_proc.proname FROM pg_proc, pg_namespace WHERE pg_proc.pronamespace=pg_namespace.oid AND pg_proc.proname LIKE '%dblink%'")
    if check_dblink.count == 0
      print "No se logro habilitar la extension dblink a la base de datos.\n"
    else
      result_connection = connection.execute("SELECT dblink_connect('cxc_server')")
      if (result_connection.first["dblink_connect"] != 'OK')
        print "No se logro conectar a la base de datos cxc.\n"
      else
        file = File.open(File.dirname(__FILE__) + "/../data/migracion.cxc.sql", "r")
        sql = file.read
        file.close
        connection.execute(sql)
        print "Migración ejecutada\n"
      end
    end
  end
end
