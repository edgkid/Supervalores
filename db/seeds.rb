# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

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
