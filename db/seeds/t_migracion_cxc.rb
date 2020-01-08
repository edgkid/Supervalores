# Los delete, update e insert mediante SQL, agregarlos en /data/migracion.cxc.sql
connection = ActiveRecord::Base.connection()

email = 'admin@cxc.com'
pass = '2019AdminCxC'

user = User.find_by(email: email)
if user == nil
  user = User.new
  user.nombre = "Cxc"
  user.apellido = "Administrador"
  user.email = email
  user.password = pass
  user.password_confirmation = pass
  user.role = "SuperAdmin"
  user.estatus = true
  user.save!
end
print "Usuario común #{email} - #{pass}\n"

TRol.create(nombre: "Administrador", descripcion:"Rol de usuario con acceso a todos los módulos del sistema", estatus: 1)
# Backup de db
#  pg_dump -Fc --no-acl --no-owner -h localhost -U postgres supervalores_development > ./data/supervalores_db.dump
# Requisitos de migracion
#  sudo -u postgres psql -U postgres -c 'CREATE DATABASE cxc';
#  sudo -u postgres psql -U postgres cxc < data/cxc_db_export.pgsql

connection = ActiveRecord::Base.connection()
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
        file = File.open(File.dirname(__FILE__) + "/../../data/migracion.cxc.sql", "r")
        sql = file.read
        file.close
        connection.execute(sql)
        print "Migración ejecutada =D\n"
      end
    end
  end
end
# Los delete, update e insert mediante SQL, agregarlos en /data/migracion.cxc.sql

TTarifaServicio.match_code_by_budget_code_from_csv(File.dirname(__FILE__) + "/../../data/prospecto.csv")
TTarifaServicio.match_code_by_budget_code_from_csv(File.dirname(__FILE__) + "/../../data/regulado.csv")

