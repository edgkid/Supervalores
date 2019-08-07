# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

email = 'admin@cxc.com'
pass = 'cxcadmin'

user = User.find_by(email: email)
if user == nil
  user = User.new
  user.email = email
  user.password = pass
  user.password_confirmation = pass
  user.save!
end

# Problema de permisos
#connection = ActiveRecord::Base.connection()
#continue = true
#
#check_previous_migration = connection.execute("SELECT * FROM schema_migrations sm WHERE sm.version = '0'")
#if check_previous_migration.count > 0
#  print "La migracion solo se hace una vez ;).\n"
#else
#  begin
#    if continue
#      connection.execute("CREATE USER migracion WITH PASSWORD 'cxc_migracion'")
#    end
#  rescue Exception => error
#    if !error.inspect.include? "already exists"
#      print "Problema =(: #{error.inspect}\n"
#      continue = false
#    end
#  end
#
#  begin
#    if continue
#      connection.execute("GRANT ALL PRIVILEGES ON DATABASE cxc to migracion")  
#    end
#  rescue Exception => error
#    if error.inspect.include? 'database "cxc" does not exist'
#      print "Problema =(: No se puede migrar sin la base de datos origen (cxc). Debes crear la base de datos cxc e importarle el archivo cxc_db_export.sql ubicado en la carpeta data dentro del proyecto.\n"
#      continue = false
#    elsif error.inspect.include? 'role "migracion" does not exist'
#      print "Problema =(: Se intento crear el usuario(migracion) pero parece que no se tienen permisos.\n"
#      continue = false
#    end
#  end
#
#  begin
#    if continue
#      connection.execute("GRANT ALL PRIVILEGES ON DATABASE cxc to postgres")  
#    end
#  rescue Exception => error
#    if error.inspect.include? 'database "cxc" does not exist'
#      print "Problema =(: No se puede migrar sin la base de datos origen (cxc). Debes crear la base de datos cxc e importarle el archivo cxc_db_export.sql ubicado en la carpeta data dentro del proyecto.\n"
#      continue = false
#    end
#  end
#
#  begin
#    if continue  
#      connection.execute("GRANT ALL PRIVILEGES ON DATABASE supervalores_development to migracion")
#    end
#  rescue Exception => error  
#    if error.inspect.include? 'database "supervalores_development" does not exist'
#      print "Problema =(: No se puede migrar sin la base de datos destino (supervalores_development).\n"
#      continue = false
#    elsif error.inspect.include? 'role "migracion" does not exist'
#      print "Problema =(: Se intento crear el usuario(migracion) pero parece que no se tienen permisos.\n"
#      continue = false
#    end
#  end
#
#  begin
#    if continue
#      connection.execute("CREATE EXTENSION dblink")
#    end
#  rescue Exception => error    
#    if !error.inspect.include?  'extension "dblink" already exists'
#      print "Problema =(: #{error.inspect}\n"
#      continue = false
#    end
#  end
#
#  begin
#    if continue
#      connection.execute("CREATE FOREIGN DATA WRAPPER cxc_db VALIDATOR postgresql_fdw_validator")
#    end
#  rescue Exception => error
#    if !error.inspect.include?  'wrapper "cxc_db" already exists'
#      print "Problema =(: #{error.inspect}\n"
#      continue = false
#    end
#  end
#
#  begin
#    if continue
#      connection.execute("CREATE SERVER cxc_server FOREIGN DATA WRAPPER cxc_db OPTIONS (hostaddr '127.0.0.1', dbname 'cxc')")
#    end
#  rescue Exception => error
#    if !error.inspect.include?  'server "cxc_server" already exists'
#      print "Problema =(: #{error.inspect}\n"
#      continue = false
#    end
#  end
#
#  #Colocar usuario de base de datos con su contraseña
#  begin
#    if continue
#      connection.execute("CREATE USER MAPPING FOR postgres SERVER cxc_server OPTIONS (user 'migracion', password 'cxc_migracion')")
#    end
#  rescue Exception => error
#    if !error.inspect.include?  'mapping for "postgres" already exists for server cxc_server'
#      print "Problema =(: #{error.inspect}\n"
#      continue = false
#    end
#  end
#
#  begin
#    if continue
#      connection.execute("GRANT USAGE ON FOREIGN SERVER cxc_server TO postgres")
#    end
#  rescue Exception => error  
#    if error.inspect.include? 'database "supervalores_development" does not exist'
#      print "Problema =(: No se puede migrar sin la base de datos destino (supervalores_development).\n"
#      continue = false
#    end
#  end
#
#  if continue
#    check_dblink = connection.execute("SELECT pg_namespace.nspname, pg_proc.proname FROM pg_proc, pg_namespace WHERE pg_proc.pronamespace=pg_namespace.oid AND pg_proc.proname LIKE '%dblink%'")
#    if check_dblink.count == 0
#      print "No se logro habilitar la extension dblink a la base de datos.\n"
#    else
#      result_connection = connection.execute("SELECT dblink_connect('cxc_server')")
#      print "#{result_connection.first.inspect}\n"
#      if (result_connection.first["dblink_connect"] != 'OK')
#        print "No se logro conectar a la base de datos cxc.\n"
#      else
#        file = File.open(File.dirname(__FILE__) + "/../data/migracion.cxc.sql", "r")
#        sql = file.read
#        file.close
#        connection.execute(sql)
#      end
#    end
#  end
#end

#Datos de prueba tipo de cuentas
#TTipoCuenta.create(descripcion: "Tipo A", estatus: 1)
#TTipoCuenta.create(descripcion: "Tipo B", estatus: 1)
#TTipoCuenta.create(descripcion: "Tipo C", estatus: 2)

#Datos Prueba Catalogo de cuentas
#TCatalogoCuentum.create(codigo:"001PA", descripcion: "Catalogo Cuenta A", estatus: 1, t_tipo_cuenta_id: 1)
#TCatalogoCuentum.create(codigo:"002PA", descripcion: "Catalogo Cuenta B", estatus: 1, t_tipo_cuenta_id: 1)
#TCatalogoCuentum.create(codigo:"003PB", descripcion: "Catalogo Cuenta C", estatus: 1, t_tipo_cuenta_id: 2)
#TCatalogoCuentum.create(codigo:"004PA", descripcion: "Catalogo Cuenta D", estatus: 1, t_tipo_cuenta_id: 3)

#Datos Prueba Presupuesto
#TPresupuesto.create( codigo:"P001", descripcion:"Presupuesto de prueba 1", estatus: 1)
#TPresupuesto.create( codigo:"P002", descripcion:"Presupuesto de prueba 2", estatus: 2)
#TPresupuesto.create( codigo:"P003", descripcion:"Presupuesto de prueba 3", estatus: 1)

#Datos Prueba Catalogo Cuenta Sub
#TCatalogoCuentaSub.create(codigo:"CTG001", descripcion:"SubCatalogo 001", estatus: 1, t_catalogo_cuentum_id: 1, t_presupuesto_id: 1)
#TCatalogoCuentaSub.create(codigo:"CTG002", descripcion:"SubCatalogo 002", estatus: 1, t_catalogo_cuentum_id: 1, t_presupuesto_id: 1)
#TCatalogoCuentaSub.create(codigo:"CTG003", descripcion:"SubCatalogo 004", estatus: 1, t_catalogo_cuentum_id: 2, t_presupuesto_id: 2)
#TCatalogoCuentaSub.create(codigo:"CTG004", descripcion:"SubCatalogo 005", estatus: 1, t_catalogo_cuentum_id: 3, t_presupuesto_id: 3)
#TCatalogoCuentaSub.create(codigo:"CTG005", descripcion:"SubCatalogo 006", estatus: 1, t_catalogo_cuentum_id: 4, t_presupuesto_id: 2)

#Datos de prueba Usuario
#--> corregir
#User.create(nombre: "Edgar", email: "edglandaeta.15@gmail.com", encrypted_password: "gdjagdgwh13dac", sign_in_count: 1)

#Datos de prueba Rol
#TRol.create(nombre: "pruebas", descripcion:"Rol para probar y desarrollar", estatus: 1)

#Datos de prueba para descripcion de rol
#--> corregir
#TRolDesc.create(nombre:"prueba a", estatus: 1)

#Datos prueba users y rols. ----> Ejucutar por SQL

#Datos prueba Tarifa
#TTarifa.create(nombre: "Tarifa A", descripcion: "descripcion Tarifa A", rango_monto: "rango prueba", recargo: 12.5, estatus: 1)
#Datos prueba tipo persona
#TTipoPersona.create(descripcion: "descripcio A", estatus: 1)

# datos prueba tipo cliente
#TTipoCliente.create(codigo:"cdgTipo001A", descripcion: "descripcion tipo A", tipo: "Tipoa A", estatus: 1, t_tarifa_id: 1)

#Datos prueba cliente padre
#TClientePadre.create(codigo: "001Padre", razon_social: "empresa Prueba", tipo_valor: "Tipoa A", sector_economico: "sector A", estatus: 1, t_tipo_persona_id: 1, t_tipo_cliente_id: 1)

#Datos de Prueba ipo de emision
#TTipoEmision.create(descripcion: "DEscripcion de Emision A", estatus: 1)

#Datos Prueba Cuenta Venta

#Datos Prueba Cliente

#Datos prueba Resolucion

#Datos prueba t_recarga

#Datos prueba recarga x cliente

#Datos prueba leyenda

#Datos prueba Periodo

#Datos prueba Metodo pago

#Datos prueba estatus factura

#Datos prueba grupos de tarifas

#Datos de pruebas tipos de clientes por tarifas ---> ejecutar SQL

#Datos de Prueba Cuenta financiera

#Datos de prueba tasa

#Datos de prueba tarifas periodo

#Datos de prueba Factua

# Datos prueba Tarifa Servicio

# Dats Prueba Factura Detalle

#Datos prueba Recibo

#Datos prueba Detalle de Recibo

#Datos prueba Caja

#Datos prueba Estado Cuenta

#Datos prueba Estado cuenta Con

#Datos de prueba emisiones

#Datos de prueba email masivos

#Datos de prueba nota credito